# frozen_string_literal: true

class SaleProductSerializer < ActiveModel::Serializer
  attributes :id,
             :amount_cents,
             :amount_currency,
             :original_amount_cents,
             :original_amount_currency,
             :quantity,
             :custom_label,
             :created_at

  belongs_to :product
end
