# frozen_string_literal: true

module Shopify
  class CustomCollectionSyncJob < BaseJob
    attr_reader :resource

    def perform(resource_id)
      @resource = find_resource(resource_id)
      @store = resource.store

      if resource.shopify_id.present?
        sync_existing_custom_collection
      else
        create_new_custom_collection
      end
    end

    private

    def get_store_id(resource_id)
      find_resource(resource_id).store.id
    end

    def sync_existing_custom_collection
      update_custom_collection(resource.shopify_id, resource.name)
      resource.update_columns(shopify_updated_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
    end

    def create_new_custom_collection
      search_results = search_custom_collection(resource.name)

      if search_results.any?
        resource.update_columns(shopify_id: search_results.first['id'], # rubocop:disable Rails/SkipsModelValidations
                                shopify_updated_at: Time.current)
      else
        create_output = create_custom_collection(resource.name)
        resource.update_columns(shopify_id: create_output['id'], # rubocop:disable Rails/SkipsModelValidations
                                shopify_updated_at: Time.current)
      end
    end

    def find_resource(_resource_id)
      throw NotImplementedError
    end

    def search_custom_collection(title)
      shopify_client
        .get(
          path: 'custom_collections',
          query: { title: },
          tries: MAX_RETRIES
        )
        .body['custom_collections']
    end

    def find_custom_collection(id)
      shopify_client
        .get(
          path: "custom_collections/#{id}",
          tries: MAX_RETRIES
        )
        .body['custom_collection']
    end

    def create_custom_collection(title)
      shopify_client
        .post(
          path: 'custom_collections',
          body: { custom_collection: { title: } },
          tries: MAX_RETRIES
        )
        .body['custom_collection']
    end

    def update_custom_collection(id, title)
      shopify_client
        .put(
          path: "custom_collections/#{id}",
          body: { custom_collection: { title: } },
          tries: MAX_RETRIES
        )
        .body['custom_collection']
    end
  end
end
