# frozen_string_literal: true

module V2
  class ProductsController < ResourcesController
    skip_before_action :set_record, only: :next_sku
    skip_after_action :verify_authorized, only: :next_sku

    def next_sku
      initial_custom_sku = 999_990_000_000
      @product = policy_scope(model_class).where("sku ~ E'^\\\\d+$'")
                                          .where(store_id: params[:store_id], sku: 999_990_000_000..nil)
                                          .order(sku: :desc)
                                          .first

      render json: {
        next_sku: @product.nil? || @product.sku.to_i.zero? ? initial_custom_sku : @product.sku.to_i + 1
      }
    end

    def included_relationships
      [:manufacturer, { category: [:category], product_custom_attributes: [:custom_attribute] }]
    end
  end
end
