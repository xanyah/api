# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :store, optional: false
  has_many :inventory_products, dependent: :destroy
  enum :status, { pending: 'pending', updating_stock: 'updating_stock', errored: 'errored', success: 'success' }

  def lock
    update(locked_at: Time.current)
    Inventory::LockJob.perform_later(id)
  end
end
