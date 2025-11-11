# frozen_string_literal: true

class AddingProgressToInventories < ActiveRecord::Migration[8.1]
  def change
    add_column :inventories, :progress, :integer, default: 0
    add_column :inventories, :stock_update_started_at, :datetime
    add_column :inventories, :stock_update_ended_at, :datetime
    add_column :inventories, :status, :string, default: :pending
  end
end
