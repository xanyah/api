# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :key,
             :city,
             :address1,
             :address2,
             :zipcode,
             :phone_number,
             :website_url,
             :email_address,
             :country,
             :created_at,
             :updated_at,
             :color,
             :is_import_enabled,
             :openai_api_key
end
