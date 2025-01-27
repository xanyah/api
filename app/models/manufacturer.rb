# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  belongs_to :store, optional: false

  has_many :products, dependent: :destroy

  validates :name, presence: true

  before_validation :set_code

  def set_code
    self.code = name.first(4).upcase if code.blank?
  end
end
