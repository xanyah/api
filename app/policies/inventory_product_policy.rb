# frozen_string_literal: true

class InventoryProductPolicy < Presets::UserEditablePolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(inventory: InventoryPolicy::Scope.new(user, Inventory).resolve)
    end
  end

  def permitted_attributes_for_create
    %i[
      inventory_id
      product_id
      quantity
    ]
  end

  def permitted_attributes_for_update
    %i[
      quantity
    ]
  end
end
