# frozen_string_literal: true

require 'faker'

france = Country.where(code: 'FRA').first_or_create do |temp_country|
  temp_country.name = 'France'
end

[2000, 1000, 550].each do |rate|
  VatRate.where(country: france, rate_percent_cents: rate).first_or_create!
end

stores = %w[EasySport Sport4000].map do |name|
  Store.where(name:).first_or_create! do |store|
    store.country = france
    store.key = name.parameterize
  end
end

%i[owner admin regular].each do |role|
  user = User.where(email: "#{role}@xanyah.io").first_or_create! do |temp_user|
    temp_user.firstname = role
    temp_user.lastname = 'User'
    temp_user.confirmed_at = Time.current
    temp_user.password = '12345678'
    temp_user.locale = 'en'
  end
  stores.each do |store|
    StoreMembership.where(store:, user:, role:).first_or_create!
  end
end

stores.each do |store|
  FactoryBot.create_list(:payment_type, 5, store:)
  FactoryBot.create_list(:customer, 20, store:)
  FactoryBot.create_list(:provider, 75, store:)
  FactoryBot.create_list(:product, 250, store:)
  FactoryBot.create_list(:order, 40, store:)
  FactoryBot.create_list(:sale, 50, store:)
end
