# frozen_string_literal: true

class PaymentTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_refund

  belongs_to :store
end
