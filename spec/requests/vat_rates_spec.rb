# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VatRates', type: :request do
  describe 'GET /vat_rates' do
    it 'works! (now write some real specs)' do
      get vat_rates_path
      expect(response).to have_http_status(:ok)
    end
  end
end
