# frozen_string_literal: true

class ShippingPolicy < Presets::UserEditablePolicy
  alias validate? store_user?
  alias cancel? store_user?

  def permitted_attributes_for_create
    [
      :state,
      :validated_at,
      :cancelled_at,
      :created_at,
      :store_id,
      :provider_id,
      { shipping_products_attributes: %i[
        product_id
        quantity
        new_buying_amount
        new_buying_amount_cents
        new_buying_amount_currency
        new_selling_amount
        new_selling_amount_cents
        new_selling_amount_currency
      ] }
    ]
  end

  def permitted_attributes_for_update
    [shipping_products_attributes: %i[
      _destroy
      id
      product_id
      quantity
      new_buying_amount
      new_buying_amount_cents
      new_buying_amount_currency
      new_selling_amount
      new_selling_amount_cents
      new_selling_amount_currency
    ]]
  end
end
