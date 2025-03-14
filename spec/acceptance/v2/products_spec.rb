# frozen_string_literal: true

require 'acceptance_helper'

resource 'Products', document: :v2 do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', :authorization

  let(:membership) { create(:store_membership, role: :admin) }
  let(:authorization) { "Bearer #{create(:access_token, resource_owner_id: membership.user_id).token}" }

  route '/v2/products', 'Products collection' do
    get 'Returns all products' do
      parameter 'q[store_id_eq]', 'Filter by store'
      parameter 'q[manufacturer_id_eq]', 'Filter by manufacturer'
      parameter 'q[provider_id_eq]', 'Filter by provider'

      before do
        create(:product)
        create(:product, store: membership.store)
      end

      example_request 'List all products' do
        expect(response_status).to eq(200)
        expect(JSON.parse(response_body).size).to eq(1)
      end
    end

    post 'Create a product' do
      with_options scope: :product, with_example: true do
        parameter :buying_amount_cents, "Product's buying amount"
        parameter :buying_amount_currency, "Product's buying amount currency"
        parameter :category_id, "Product's category id", required: true
        parameter :manufacturer_id, "Product's manufacturer id", required: true
        parameter :manufacturer_sku, "Product's manufacturer SKU", required: true
        parameter :name, "Product's name", required: true
        parameter :provider_id, "Product's provider"
        parameter :sku, "Product's SKU (store barcode of the product. Can be UPC)"
        parameter :store_id, "Product's store id", required: true
        parameter :vat_rate_id, "Product's VAT rate", required: true
        parameter :tax_free_amount_cents, "Product's tax free amount"
        parameter :tax_free_amount_currency, "Product's tax free amount currency"
        parameter :upc, "Product's UPC (original barcode of the product)"
      end

      let(:name) { product[:name] }
      let(:category_id) { create(:category, store: membership.store).id }
      let(:manufacturer_id) { create(:manufacturer, store: membership.store).id }
      let(:provider_id) { create(:provider, store: membership.store).id }
      let(:vat_rate_id) { VatRate.first.id }
      let(:store_id) { membership.store_id }
      let(:product) { attributes_for(:product, store: membership.store) }

      example_request 'Create a product' do
        expect(response_status).to eq(201)
        expect(JSON.parse(response_body)['id']).to be_present
      end
    end
  end

  route '/v2/products/next_sku', 'Products collection' do
    get 'Returns next SKU' do
      parameter 'store_id', 'Filter by store'

      example_request 'Returns next SKU' do
        expect(response_status).to eq(200)
        expect(JSON.parse(response_body)['next_sku']).to be_a(Integer)
      end
    end
  end

  route '/v2/products/:id', 'Single product' do
    let!(:product) { create(:product, store: membership.store) }

    get 'Get a specific product' do
      let(:id) { product.id }

      example_request 'Getting a product' do
        expect(status).to eq(200)
        body = JSON.parse(response_body)
        expect(body['id']).to eq(id)
        expect(body['name']).to eq(product.name)
      end
    end

    patch 'Update a specific product' do
      with_options scope: :product, with_example: true do
        parameter :buying_amount_cents, "Product's buying amount"
        parameter :buying_amount_currency, "Product's buying amount currency"
        parameter :category_id, "Product's category id"
        parameter :manufacturer_id, "Product's manufacturer id"
        parameter :manufacturer_sku, "Product's manufacturer SKU"
        parameter :name, "Product's name"
        parameter :provider_id, "Product's provider"
        parameter :vat_rate_id, "Product's VAT rate"
        parameter :sku, "Product's SKU (store barcode of the product. Can be UPC)"
        parameter :tax_free_amount_cents, "Product's tax free amount"
        parameter :tax_free_amount_currency, "Product's tax free amount currency"
        parameter :upc, "Product's UPC (original barcode of the product)"
      end

      let(:id) { product.id }
      let(:name) { build(:product).name }

      example_request 'Updating a product' do
        expect(status).to eq(200)
        body = JSON.parse(response_body)
        expect(body['id']).to eq(id)
        expect(body['name']).to eq(name)
      end
    end

    delete 'Destroy a specific product' do
      let(:id) { product.id }

      example_request 'Destroying a product' do
        expect(status).to eq(204)
      end
    end
  end
end
