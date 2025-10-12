# frozen_string_literal: true

class AddCustomLabelToSaleProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :sale_products, :custom_label, :string
  end
end
