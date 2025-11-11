# frozen_string_literal: true

module Shopify
  class CategorySyncJob < CustomCollectionSyncJob
    def find_resource(resource_id)
      Category.find(resource_id)
    end
  end
end
