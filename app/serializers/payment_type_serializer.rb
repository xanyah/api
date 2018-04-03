# frozen_string_literal: true

class PaymentTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  belongs_to :store
end
