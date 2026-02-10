# frozen_string_literal: true

class ShippingProductSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :new_buying_amount_cents, :new_buying_amount_currency, :new_selling_amount_cents, :new_selling_amount_currency

  belongs_to :product
end
