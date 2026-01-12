# frozen_string_literal: true

module Shopify
  class ProductTagBuilder
    def initialize(product)
      @product = product
    end

    def build
      tags = [
        stock_level_tag,
        image_presence_tag,
        manufacturer_tag,
        category_hierarchy_tags
      ].flatten.compact.uniq

      Rails.logger.info("Generated Shopify tags for product_id=#{product.id}: #{tags.join(', ')}")
      tags
    end

    private

    attr_reader :product

    def manufacturer_tag
      return nil if product.manufacturer&.name.blank?

      "manufacturer:#{slugify(product.manufacturer.name)}"
    end

    def stock_level_tag
      product.quantity.positive? ? 'stock:in-stock' : 'stock:out-of-stock'
    end

    def image_presence_tag
      product.images.attached? ? 'image:with-image' : 'image:without-image'
    end

    def category_hierarchy_tags
      tags = []
      current_category = product.category

      while current_category.present?
        tags << "category:#{slugify(current_category.name)}"
        current_category = current_category.category
      end

      tags
    end

    def slugify(text)
      return nil if text.blank?

      text.parameterize
    end
  end
end
