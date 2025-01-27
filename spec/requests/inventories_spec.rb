# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Inventories' do
  let(:store_membership) { create(:store_membership) }
  let(:store) { store_membership.store }
  let(:user) { store_membership.user }

  describe 'GET /inventories' do
    it 'returns only permitted inventories' do
      create(:inventory)
      create(:inventory, store: store)
      get inventories_path, headers: user.create_new_auth_token
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(1)
    end

    it 'return empty if !membership' do
      get inventories_path, headers: create(:user).create_new_auth_token
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(0)
    end

    it 'returns 401 if !loggedin' do
      get inventories_path
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /inventories/:id' do
    it 'returns inventory if membership' do
      inventory = create(:inventory, store: store)
      get inventory_path(inventory), headers: user.create_new_auth_token
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['id']).to be_present
    end

    it 'returns 401 if !membership' do
      get inventory_path(create(:inventory)), headers: create(:user).create_new_auth_token
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if !loggedin' do
      get inventory_path(create(:inventory))
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to have_key('errors')
    end
  end

  describe 'PATCH /inventories/:id/lock' do
    it 'updates inventory if membership' do
      store_membership.update(role: :admin)
      inventory = create(:inventory, store: store, locked_at: nil)
      patch lock_inventory_path(inventory), headers: user.create_new_auth_token
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['locked_at']).not_to be_nil
    end

    it 'returns 401 if !membership' do
      patch lock_inventory_path(create(:inventory)), headers: create(:user).create_new_auth_token
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if !loggedin' do
      patch lock_inventory_path(create(:inventory))
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to have_key('errors')
    end
  end

  describe 'DELETE /inventories/:id' do
    it 'deletes inventory product if membership >= admin' do
      store_membership.update(role: :admin)
      inventory = create(:inventory, store: store, locked_at: nil)
      delete inventory_path(inventory), headers: store_membership.user.create_new_auth_token
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 401 if membership < admin' do
      store_membership.update(role: :regular)
      inventory = create(:inventory, store: store, locked_at: nil)
      delete inventory_path(inventory), headers: store_membership.user.create_new_auth_token
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if locked' do
      store_membership.update(role: :admin)
      inventory = create(:inventory, store: store, locked_at: nil)
      inventory.lock
      delete inventory_path(inventory), headers: store_membership.user.create_new_auth_token
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if !membership' do
      delete inventory_path(create(:inventory)), headers: create(:user).create_new_auth_token
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to have_key('errors')
    end

    it 'returns 401 if !loggedin' do
      delete inventory_path(create(:inventory))
      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body).to have_key('errors')
    end
  end
end
