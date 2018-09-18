# frozen_string_literal: true

require 'acceptance_helper'

resource 'Providers' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Access-Token', :access_token
  header 'Token-Type', :token_type
  header 'Client', :client_id
  header 'Expiry', :expiry
  header 'Uid', :uid

  let(:membership) { create(:store_membership, role: :admin) }
  let(:auth_token) { membership.user.create_new_auth_token }
  let(:access_token) { auth_token['access-token'] }
  let(:token_type) { auth_token['token-type'] }
  let(:client_id) { auth_token['client'] }
  let(:expiry) { auth_token['expiry'] }
  let(:uid) { auth_token['uid'] }

  route '/providers', 'Providers collection' do
    get 'Returns all providers' do
      parameter :store_id, 'Filter by store'

      before do
        create(:provider)
        create(:provider, store: membership.store)
      end

      example_request 'List all providers' do
        expect(response_status).to eq(200)
        expect(JSON.parse(response_body).size).to eq(1)
      end
    end

    post 'Create a provider' do
      with_options scope: :provider do
        parameter :name, "Provider's name", required: true
        parameter :notes, 'Notes about provider'
        parameter :store_id, "Provider's store id", required: true
      end

      let(:name) { provider[:name] }
      let(:notes) { provider[:notes] }
      let(:store_id) { membership.store_id }
      let(:provider) { attributes_for(:provider) }

      example_request 'Create a provider' do
        expect(response_status).to eq(201)
        expect(JSON.parse(response_body)['id']).to be_present
      end
    end
  end

  route '/providers/:id', 'Single provider' do
    let!(:provider) { create(:provider, store: membership.store) }

    with_options scope: :provider do
      parameter :name, "Provider's name", required: true
      parameter :notes, 'Notes about provider'
    end

    get 'Get a specific provider' do
      let(:id) { provider.id }

      example_request 'Getting a provider' do
        expect(status).to eq(200)
        body = JSON.parse(response_body)
        expect(body['id']).to eq(id)
        expect(body['name']).to eq(provider.name)
      end
    end

    patch 'Update a specific provider' do
      let(:id) { provider.id }
      let(:name) { build(:provider).name }

      example_request 'Updating a provider' do
        expect(status).to eq(200)
        body = JSON.parse(response_body)
        expect(body['id']).to eq(id)
        expect(body['name']).to eq(name)
      end
    end

    delete 'Destroy a specific provider' do
      let(:id) { provider.id }

      example_request 'Destroying a provider' do
        expect(status).to eq(204)
      end
    end
  end

  route '/providers/search', 'Manufacturers collection' do
    let!(:provider) { create(:provider, store: membership.store) }

    parameter :store_id, 'Filter by store'
    parameter :query, 'Search query', required: true

    get 'Search providers' do
      let(:query) { provider.name }

      example_request 'Searching providers' do
        expect(status).to eq(200)
        body = JSON.parse(response_body)
        expect(body.size).to eq(1)
      end
    end
  end
end
