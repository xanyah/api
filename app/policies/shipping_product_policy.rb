# frozen_string_literal: true

class ShippingProductPolicy < Presets::UserEditablePolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(shipping: ShippingPolicy::Scope.new(user, Shipping).resolve)
    end
  end

  def permitted_attributes_for_create
    %i[
      shipping_id
      product_id
      quantity
      new_amount
    ]
  end

  def permitted_attributes_for_update
    %i[
      quantity
      new_amount
    ]
  end
end
