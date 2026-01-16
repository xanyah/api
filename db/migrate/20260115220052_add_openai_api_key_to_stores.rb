# frozen_string_literal: true

class AddOpenaiApiKeyToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :openai_api_key, :string
  end
end
