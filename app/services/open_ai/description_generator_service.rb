# frozen_string_literal: true

require 'net/http'
require 'json'

module OpenAi
  class DescriptionGeneratorService # rubocop:disable Metrics/ClassLength
    class MissingApiKeyError < StandardError; end

    OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'

    def initialize(product)
      @product = product
      @store = product.store
    end

    def generate
      raise MissingApiKeyError, 'OpenAI API key not configured for this store' unless api_key_present?

      response = call_openai_api
      parse_response(response)
    end

    private

    attr_reader :product, :store

    def api_key_present?
      store.openai_api_key.present?
    end

    def call_openai_api
      uri = URI(OPENAI_API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30

      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = request_body.to_json

      http.request(request)
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{store.openai_api_key}"
      }
    end

    def request_body
      {
        model: 'gpt-4o-mini',
        messages: [
          {
            role: 'system',
            content: build_system_prompt
          },
          {
            role: 'user',
            content: build_user_prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 800,
        response_format: { type: 'json_object' }
      }
    end

    def build_system_prompt # rubocop:disable Metrics/MethodLength
      base_prompt = [
        'You are an expert e-commerce copywriter specialized in creating SEO-optimized product descriptions.',
        'Your task is to analyze a product and provide suggestions for improvement.',
        '',
        'Rules:',
        '1. Generate descriptions in HTML format using proper tags (<p>, <h3>, <ul>, <li>, <strong>, <em>)',
        '2. Make descriptions engaging, informative, and SEO-friendly',
        "3. If you don't recognize the product or lack sufficient information, respond with null for both title and description",
        '4. NEVER invent features or specifications - only describe what you can reasonably infer from the provided information',
        '5. For the title: suggest an improved, SEO-friendly version only if the current one is too short, vague, or not descriptive',
        '6. If the current title is adequate, return null for the title field',
        '7. Focus on benefits, features, and use cases when writing descriptions',
        '8. Use keywords naturally for better SEO',
        '',
        'Response format (JSON):',
        '{',
        '  "title": "improved title or null if current is adequate",',
        '  "description": "HTML formatted description or null if product is not recognized"',
        '}'
      ].join("\n")

      return base_prompt if store.ai_prompt.blank?

      "#{base_prompt}\n\nAdditional store-specific instructions:\n#{store.ai_prompt}"
    end

    def build_user_prompt # rubocop:disable Metrics/AbcSize
      prompt_parts = []
      prompt_parts << "Product Name: #{product.name}"
      prompt_parts << "Current description: #{product.description}" if product.description.present?
      prompt_parts << build_category_path if product.category
      prompt_parts << "Manufacturer: #{product.manufacturer.name}" if product.manufacturer
      prompt_parts << build_custom_attributes if product.product_custom_attributes.any?
      prompt_parts << "\nAnalyze this product and provide your suggestions in JSON format."
      prompt_parts.compact.join("\n\n")
    end

    def build_category_path
      category_path = [product.category.name]
      parent = product.category.category
      while parent
        category_path.unshift(parent.name)
        parent = parent.category
      end
      "Category: #{category_path.join(' > ')}"
    end

    def build_custom_attributes
      attributes = product.product_custom_attributes.filter_map do |pca|
        "#{pca.custom_attribute.name}: #{pca.value}" if pca.value.present?
      end
      "Product Attributes:\n#{attributes.join("\n")}" if attributes.any?
    end

    def parse_response(response)
      case response
      when Net::HTTPSuccess
        body = JSON.parse(response.body)
        content = body.dig('choices', 0, 'message', 'content')
        suggestions = JSON.parse(content)

        {
          title: suggestions['title'],
          description: suggestions['description']
        }
      else
        Rails.logger.error("OpenAI API error: #{response.code} - #{response.body}")
        raise StandardError, "OpenAI API returned error: #{response.code}"
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse OpenAI response: #{e.message}")
      raise StandardError, 'Invalid response from OpenAI API'
    end
  end
end
