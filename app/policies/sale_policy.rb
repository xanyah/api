# frozen_string_literal: true

class SalePolicy < Presets::UserEditablePolicy
  def permitted_attributes_for_create # rubocop:disable Metrics/MethodLength
    [
      :created_at,
      :store_id,
      :customer_id,
      :total_amount_cents,
      :total_amount_currency,
      { sale_products_attributes: %i[
          product_id
          quantity
          amount_cents
          amount_currency
          original_amount_cents
          original_amount_currency
          custom_label
        ],
        sale_payments_attributes: %i[
          payment_type_id
          total_amount_cents
          total_amount_currency
        ],
        sale_promotion_attributes: %i[type amount_cents amount_currency] }
    ]
  end

  def permitted_attributes_for_update
    if record.customer_id.nil?
      %i[customer_id]
    else
      []
    end
  end
end
