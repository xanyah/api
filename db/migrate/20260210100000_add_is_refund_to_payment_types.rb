# frozen_string_literal: true

class AddIsRefundToPaymentTypes < ActiveRecord::Migration[8.1]
  def change
    add_column :payment_types, :is_refund, :boolean, default: false, null: false
  end
end
