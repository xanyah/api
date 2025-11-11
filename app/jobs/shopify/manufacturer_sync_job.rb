# frozen_string_literal: true

module Shopify
  class ManufacturerSyncJob < CustomCollectionSyncJob
    def find_resource(resource_id)
      Manufacturer.find(resource_id)
    end
  end
end
