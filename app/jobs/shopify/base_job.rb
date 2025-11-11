# frozen_string_literal: true

module Shopify
  class BaseJob < ApplicationJob
    attr_reader :store

    include GoodJob::ActiveJobExtensions::Concurrency

    # Define the concurrency control using a key based on the calculated store_id
    good_job_control_concurrency_with(
      perform_limit: 1,
      key: -> { "shopify-sync-#{get_store_id(arguments)}" }
    )

    MAX_RETRIES = 5

    def shopify_client
      @shopify_client ||= ShopifyAPI::Clients::Rest::Admin.new(api_version: '2025-10',
                                                               session: shopify_session)
    end

    def shopify_session
      raise ArgumentError, 'Store must be set' if store.nil?
      raise ArgumentError, "Store #{store.id} is not Shopify enabled" unless store.shopify_enabled?

      if @shopify_session.nil?
        @shopify_session = ShopifyAPI::Auth::Session.new(
          shop: store.shopify_shop,
          access_token: store.shopify_access_token
        )
        ShopifyAPI::Context.activate_session(@shopify_session)
      end
      @shopify_session
    end

    def get_store_id(_arguments)
      raise NotImplementedError
    end
  end
end
