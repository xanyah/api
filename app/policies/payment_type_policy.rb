# frozen_string_literal: true

class PaymentTypePolicy < Presets::AdminEditablePolicy
  def permitted_attributes_for_create
    %i[name description store_id is_refund]
  end

  def permitted_attributes_for_update
    %i[name description is_refund]
  end
end
