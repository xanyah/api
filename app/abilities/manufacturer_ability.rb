# frozen_string_literal: true

module ManufacturerAbility
  def manufacturer_ability(user)
    can :manage, Manufacturer do |manufacturer|
      !manufacturer.store_id.nil? && manufacturer.store.users.include?(user)
    end
  end
end
