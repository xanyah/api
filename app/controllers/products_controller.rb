# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /products
  def index
    @products = current_user.stores.map(&:products).flatten
    @products = @products.select {|c| c.store_id == params[:store_id] } if params[:store_id].present?

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    if @product.save
      @variant = Variant.create(variant_params)
      @variant.product_id = @product.id
      @variant.default = true
      if @variant.save
        render json: @variant, status: :created, location: @variant
      else
        render json: @variant.errors, status: :unprocessable_entity
      end
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(update_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def create_params
    params.require(:product).permit(:name, :category_id, :manufacturer_id, :store_id)
  end

  def variant_params
    params.require(:variant).permit(:buying_price, :tax_free_price, :provider_id, :ratio)
  end

  def update_params
    params.require(:product).permit(:name, :category_id, :manufacturer_id)
  end
end
