# frozen_string_literal: true

class ProductCustomAttribute < ApplicationRecord
  belongs_to :product
  belongs_to :custom_attribute

  has_one :store, through: :custom_attribute

  validates :product, uniqueness: { scope: :custom_attribute_id }

  validates_ownership_of :product, with: :store
end
