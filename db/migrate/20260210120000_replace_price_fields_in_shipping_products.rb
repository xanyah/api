# frozen_string_literal: true

class ReplacePriceFieldsInShippingProducts < ActiveRecord::Migration[8.1]
  def change
    # Renommer les champs existants pour le prix de vente
    rename_column :shipping_products, :new_amount_cents, :new_selling_amount_cents
    rename_column :shipping_products, :new_amount_currency, :new_selling_amount_currency

    # Ajouter les nouveaux champs pour le prix d'achat
    add_column :shipping_products, :new_buying_amount_cents, :integer
    add_column :shipping_products, :new_buying_amount_currency, :string, default: 'EUR', null: false
  end
end
