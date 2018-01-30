class VariantAttribute < ApplicationRecord
  belongs_to :variant, optional: false
  belongs_to :custom_attribute, optional: false

  validates :custom_attribute_id, uniqueness: { scope: :variant_id }
end
