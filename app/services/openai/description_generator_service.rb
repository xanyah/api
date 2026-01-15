# frozen_string_literal: true

require 'net/http'
require 'json'

module OpenAI
  class DescriptionGeneratorService
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
            content: 'You are a helpful assistant that writes product descriptions in HTML format. ' \
                     'Use proper HTML tags like <p>, <h3>, <ul>, <li>, <strong>, <em> to format the description. ' \
                     'Make the description engaging, informative, and suitable for e-commerce.'
          },
          {
            role: 'user',
            content: build_prompt
          }
        ],
        temperature: 0.7,
        max_tokens: 500
      }
    end

    def build_prompt
      prompt = "Write a product description in HTML format for the following product:\n\n"
      prompt += "Product Name: #{product.name}\n"
      prompt += "Category: #{product.category&.name}\n" if product.category
      prompt += "Manufacturer: #{product.manufacturer&.name}\n" if product.manufacturer
      prompt += "SKU: #{product.sku}\n" if product.sku.present?
      prompt += "\nPlease create an engaging and informative HTML description for this product."
      prompt
    end

    def parse_response(response)
      case response
      when Net::HTTPSuccess
        body = JSON.parse(response.body)
        body.dig('choices', 0, 'message', 'content')
      else
        Rails.logger.error("OpenAI API error: #{response.code} - #{response.body}")
        raise StandardError, "OpenAI API returned error: #{response.code}"
      end
    end
  end
end
