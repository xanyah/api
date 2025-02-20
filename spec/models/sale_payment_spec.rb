# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SalePayment do
  it :has_valid_factory do
    expect(create(:sale_payment)).to be_valid
  end

  it :is_paranoid do
    sale_payment = create(:sale_payment)
    expect(sale_payment.deleted_at).to be_nil
    expect(described_class.all).to include(sale_payment)
    sale_payment.destroy
    expect(sale_payment.deleted_at).not_to be_nil
    expect(described_class.all).not_to include(sale_payment)
  end

  describe 'validations' do
    describe 'sale' do
      it :presence do
        expect(build(:sale_payment, sale: nil)).not_to be_valid
      end
    end
  end
end
