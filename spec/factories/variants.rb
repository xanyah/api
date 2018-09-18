# frozen_string_literal: true

FactoryBot.define do
  factory :variant do
    original_barcode { Faker::Number.number(10).to_s }
    buying_price { rand(1..100).to_f / 10 }
    default { false }
    ratio { rand(1..20).to_f / 10 }
    tax_free_price { (buying_price * ratio).round(2) }
    product
    provider
  end
end
