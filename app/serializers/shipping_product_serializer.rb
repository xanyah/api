# frozen_string_literal: true

class ShippingProductSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :new_amount_cents, :new_amount_currency

  belongs_to :product
end
