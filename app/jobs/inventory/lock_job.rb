# frozen_string_literal: true

class Inventory
  class LockJob < ApplicationJob
    queue_as :default

    def perform(inventory_id)
      inventory = Inventory.find(inventory_id)

      inventory.update!(stock_update_started_at: Time.current, status: :updating_stock)
      ActiveRecord::Base.transaction do
        update_products_quantities!(inventory)
        inventory.update!(stock_update_ended_at: Time.current, status: :success)
      end
    rescue StandardError => e
      Rails.logger.error(
        "[Inventory::LockJob] Failed to update inventory ##{inventory_id}: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
      )
      inventory.update!(status: :failed)
      raise ActiveRecord::Rollback
    end

    private

    def update_products_quantities!(inventory)
      inventory_products = inventory.inventory_products
      total = inventory_products.count

      inventory_products.each_with_index do |inventory_product, index|
        Rails.logger.info("[Inventory::LockJob] Updating product ##{inventory_product.product_id} quantity to #{inventory_product.quantity}")
        inventory_product.product.update!(quantity: inventory_product.quantity)

        inventory.update!(progress: ((index + 1).to_f / total * 100).round)
      end
    end
  end
end
