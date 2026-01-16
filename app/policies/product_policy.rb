# frozen_string_literal: true

class ProductPolicy < Presets::UserEditablePolicy
  def permitted_attributes_for_create # rubocop:disable Metrics/MethodLength
    [
      :name,
      :description,
      :category_id,
      :manufacturer_id,
      :store_id,
      :amount,
      :amount_cents,
      :amount_currency,
      :buying_amount,
      :buying_amount_cents,
      :buying_amount_currency,
      :quantity,
      :tax_free_amount,
      :tax_free_amount_cents,
      :tax_free_amount_currency,
      :sku,
      :upc,
      :manufacturer_sku,
      :vat_rate_id,
      { product_custom_attributes_attributes: %i[custom_attribute_id value],
        images: [] }
    ]
  end

  def permitted_attributes_for_update # rubocop:disable Metrics/MethodLength
    [
      :name,
      :description,
      :category_id,
      :manufacturer_id,
      :amount,
      :amount_cents,
      :amount_currency,
      :buying_amount,
      :buying_amount_cents,
      :buying_amount_currency,
      :tax_free_amount,
      :tax_free_amount_cents,
      :tax_free_amount_currency,
      :sku,
      :upc,
      :manufacturer_sku,
      :vat_rate_id,
      { product_custom_attributes_attributes: %i[id custom_attribute_id value],
        images: [] }
    ]
  end
end
