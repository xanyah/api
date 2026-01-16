# frozen_string_literal: true

class AddAiPromptToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :ai_prompt, :text
  end
end
