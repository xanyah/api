# frozen_string_literal: true

class Category < ApplicationRecord
  before_validation :set_tva
  belongs_to :store, optional: false
  belongs_to :category, optional: true
  belongs_to :vat_rate, optional: false

  validates :name, presence: true, uniqueness: { scope: :category }

  scope :without_category, -> { where(category_id: nil) }
  scope :children_of, ->(id) { where(category_id: id) }

  protected

  def set_tva
    self.tva = :standard_rate if tva.nil?
  end
end
