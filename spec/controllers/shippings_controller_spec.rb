# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe ShippingsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Shipping. As you add validations to Shipping, be sure to
  # adjust the attributes here as well.
  let(:store_membership) { create(:store_membership, role: :admin) }
  let(:user) { store_membership.user }
  let(:valid_attributes) {
    attributes_for(:shipping,
      provider_id: create(:provider, store: store_membership.store).id,
      store_id: store_membership.store_id,
      locked_at: nil)
  }

  let(:invalid_attributes) {
    {
      store_id: nil
    }}

  describe 'GET #index' do
    it 'returns a success response' do
      Shipping.create! valid_attributes
      request.headers.merge! user.create_new_auth_token
      get :index, params: {}
      expect(response).to be_success
    end

    it 'filters by store' do
      Shipping.create! valid_attributes
      item = Shipping.create! valid_attributes
      item.update(store: create(:store_membership, user: user).store)
      request.headers.merge! user.create_new_auth_token
      get :index, params: {store_id: valid_attributes[:store_id]}
      expect(response).to be_success
      expect(JSON.parse(response.body).size).to eq(1)
      get :index, params: {}
      expect(response).to be_success
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      shipping = Shipping.create! valid_attributes
      request.headers.merge! user.create_new_auth_token
      get :show, params: {id: shipping.to_param}
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Shipping' do
        request.headers.merge! user.create_new_auth_token
        expect {
          post :create, params: {shipping: valid_attributes}
        }.to change(Shipping, :count).by(1)
      end

      it 'renders a JSON response with the new shipping' do
        request.headers.merge! user.create_new_auth_token
        post :create, params: {shipping: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(shipping_url(Shipping.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new shipping' do
        request.headers.merge! user.create_new_auth_token
        post :create, params: {shipping: invalid_attributes}
        expect(response).not_to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #lock' do
    context 'with valid params' do
      it 'updates the requested shipping' do
        shipping = Shipping.create! valid_attributes
        request.headers.merge! user.create_new_auth_token
        put :lock, params: {id: shipping.to_param}
        shipping.reload
        expect(shipping.locked_at).not_to eq(nil)
      end

      it 'renders a JSON response with the shipping' do
        shipping = Shipping.create! valid_attributes

        request.headers.merge! user.create_new_auth_token
        put :lock, params: {id: shipping.to_param}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested shipping' do
      shipping = Shipping.create! valid_attributes
      request.headers.merge! user.create_new_auth_token
      expect {
        delete :destroy, params: {id: shipping.to_param}
      }.to change(Shipping, :count).by(-1)
    end
  end
end
