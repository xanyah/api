# frozen_string_literal: true

module Shopify
  class BaseJob < ApplicationJob
    attr_reader :store

    MAX_RETRIES = 5

    def shopify_client
      @shopify_client ||= ShopifyAPI::Clients::Rest::Admin.new(session: shopify_session)
    end

    def shopify_session
      if @shopify_session.nil?
        @shopify_session = ShopifyAPI::Auth::Session.new(
          shop: store.shopify_shop,
          access_token: store.shopify_access_token
        )
        ShopifyAPI::Context.activate_session(@shopify_session)
      else
        @shopify_session
      end
    end
  end
end
