# frozen_string_literal: true

require 'csv'
require 'json'

class FileImportWorker
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker

  def perform(file_import_id)
    @file_import = FileImport.find(file_import_id)

    return if @file_import.nil?

    @store_id = @file_import.store_id
    file = @file_import.file

    return if file.nil?

    begin
      ActiveRecord::Base.transaction do
        case File.extname(file.filename.to_s)
        when '.csv'
          CSV.parse(file.download, headers: true, encoding: 'UTF-8') do |row|
            create_product row.to_hash
          end
        when '.json'
          JSON.parse(file.download).each do |row|
            create_product row
          end
        end
      end
      @file_import.update(processed: true)
    end
  end

  def create_product(params)
    manufacturer = Manufacturer.find_or_create_by(name: params['product_manufacturer'], store_id: @store_id)
    provider = Provider.find_or_create_by(name: params['variant_provider'], store_id: @store_id)
    category = Category.find_or_create_by(name: params['product_category'], store_id: @store_id)
    product = Product.create!(
      name:         params['product_name'],
      category:     category,
      manufacturer: manufacturer,
      store_id:     @store_id
    )
    Variant.create!(
      original_barcode: params['variant_original_barcode'],
      buying_price:     params['variant_buying_price'].to_f,
      tax_free_price:   params['variant_tax_free_price'].to_f,
      ratio:            params['variant_ratio'].to_f,
      provider:         provider,
      product:          product
    )
  end
end
