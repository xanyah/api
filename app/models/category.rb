# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :store, optional: false
  belongs_to :category, optional: true

  validates_ownership_of :category, with: :store

  validates :name, presence: true, uniqueness: { scope: %i[category store] }

  scope :without_category, -> { where(category_id: nil) }
  scope :children_of, ->(id) { where(category_id: id) }
end
