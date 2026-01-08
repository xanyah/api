# frozen_string_literal: true

class Inventory
  class LockJob < ApplicationJob
    queue_as :default

    def perform(inventory_id)
      inventory = Inventory.find(inventory_id)

      ActiveRecord::Base.transaction do
        inventory.update!(stock_update_started_at: Time.current, status: :updating_stock)
        update_products_quantities!(inventory)
        inventory.update!(stock_update_ended_at: Time.current, status: :success)
      end
    rescue StandardError => e
      Rails.logger.error(
        "[Inventory::LockJob] Failed to update inventory ##{inventory_id}: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
      )
      inventory.update!(status: :failed)
      raise
    end

    private

    def update_products_quantities!(inventory) # rubocop:disable Metrics/AbcSize
      inventory_products = inventory.inventory_products
      inventoried_product_ids = inventory_products.pluck(:product_id)
      total = inventory_products.count

      # Update products that are in the inventory
      inventory_products.each_with_index do |inventory_product, index|
        Rails.logger.info("[Inventory::LockJob] Updating product ##{inventory_product.product_id} quantity to #{inventory_product.quantity}")
        inventory_product.product.update!(quantity: inventory_product.quantity)

        inventory.update!(progress: ((index + 1).to_f / total * 100).round)
      end

      # Set quantity to 0 for products not in this inventory (scoped to the store)
      Product.where(store_id: inventory.store_id)
             .where.not(id: inventoried_product_ids)
             .update_all(quantity: 0) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
