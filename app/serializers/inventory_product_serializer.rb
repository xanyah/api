# frozen_string_literal: true

class InventoryProductSerializer < ActiveModel::Serializer
  attributes :id, :quantity

  belongs_to :product
end
