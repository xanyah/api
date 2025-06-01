# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :amount_cents,
             :amount_currency,
             :buying_amount_cents,
             :buying_amount_currency,
             :tax_free_amount_cents,
             :tax_free_amount_currency,
             :quantity,
             :sku,
             :upc,
             :manufacturer_sku,
             :images,
             :created_at,
             :updated_at

  belongs_to :category
  belongs_to :manufacturer
  belongs_to :vat_rate

  has_many :product_custom_attributes

  def images
    object.images.map do |image|
      {
        large: image_variant_path(image, :large),
        medium: image_variant_path(image, :medium),
        open_graph: image_variant_path(image, :open_graph),
        thumbnail: image_variant_path(image, :thumbnail),
        signed_id: image.signed_id
      }
    end
  end

  private

  def image_variant_path(image, variant)
    rails_representation_url(image.variant(variant), only_path: true)
  rescue
    nil
  end
end
