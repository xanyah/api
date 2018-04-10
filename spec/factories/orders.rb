# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    status { %i[pending delivered canceled].sample }
    client
    store
  end
end
