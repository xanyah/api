# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreMembership, type: :model do
  it :has_valid_factory do
    expect(build(:store_membership)).to be_valid
  end

  it :is_paranoid do
    store_membership = create(:store_membership)
    expect(store_membership.deleted_at).to be_nil
    expect(StoreMembership.all).to include(store_membership)
    store_membership.destroy
    expect(store_membership.deleted_at).not_to be_nil
    expect(StoreMembership.all).not_to include(store_membership)
  end

  describe 'validations' do
    it :uniqueness do
      membership = create(:store_membership)
      expect(build(:store_membership, store: membership.store)).to be_valid
      expect(build(:store_membership, user: membership.user)).to be_valid
      expect(build(:store_membership, user: membership.user, store: membership.store)).not_to be_valid
    end

    it :presence do
      expect(build(:store_membership, store: nil)).not_to be_valid
      expect(build(:store_membership, user: nil)).not_to be_valid
    end
  end

  describe 'abilities' do
    describe 'everyone' do
      it :cannot_create do
        expect(Ability.new(build(:user))).not_to be_able_to(:create, build(:store_membership))
      end
      it :cannot_read do
        expect(Ability.new(build(:user))).not_to be_able_to(:read, build(:store_membership))
      end
      it :cannot_update do
        expect(Ability.new(build(:user))).not_to be_able_to(:update, build(:store_membership))
      end
      it :cannot_destroy do
        expect(Ability.new(build(:user))).not_to be_able_to(:destroy, build(:store_membership))
      end
    end

    describe 'regular' do
      let(:membership) { create(:store_membership, role: :regular) }

      it :create do
        expect(Ability.new(membership.user)).not_to be_able_to(
          :create, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :create, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :create, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :read do
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :update do
        expect(Ability.new(membership.user)).not_to be_able_to(
          :update, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :update, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :update, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :cannot_destroy do
        expect(Ability.new(membership.user)).not_to be_able_to(
          :destroy, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :destroy, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :destroy, build(:store_membership, role: :owner, store: membership.store)
        )
      end
    end

    describe 'admin' do
      let(:membership) { create(:store_membership, role: :admin) }

      it :create do
        expect(Ability.new(membership.user)).to be_able_to(
          :create, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :create, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :create, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :read do
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :update do
        expect(Ability.new(membership.user)).to be_able_to(
          :update, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :update, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :update, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :destroy do
        expect(Ability.new(membership.user)).to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :regular)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :admin)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :owner)
        )
      end
    end

    describe 'owner' do
      let(:membership) { create(:store_membership, role: :owner) }

      it :create do
        expect(Ability.new(membership.user)).to be_able_to(
          :create, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :create, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :create, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :read do
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :read, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :update do
        expect(Ability.new(membership.user)).to be_able_to(
          :update, build(:store_membership, role: :regular, store: membership.store)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :update, build(:store_membership, role: :admin, store: membership.store)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :update, build(:store_membership, role: :owner, store: membership.store)
        )
      end
      it :destroy do
        expect(Ability.new(membership.user)).to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :regular)
        )
        expect(Ability.new(membership.user)).to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :admin)
        )
        expect(Ability.new(membership.user)).not_to be_able_to(
          :destroy, build(:store_membership, store: membership.store, role: :owner)
        )
      end
    end

    describe 'with other store permissions' do
      let(:regular_membership) { create(:store_membership, role: :regular) }
      let(:admin_membership) { create(:store_membership, role: :admin) }
      let(:owner_membership) { create(:store_membership, role: :owner) }

      it :cannot_create do
        expect(Ability.new(regular_membership)).not_to be_able_to(:create, build(:store_membership))
        expect(Ability.new(admin_membership)).not_to be_able_to(:create, build(:store_membership))
        expect(Ability.new(owner_membership)).not_to be_able_to(:create, build(:store_membership))
      end
      it :cannot_read do
        expect(Ability.new(regular_membership)).not_to be_able_to(:read, build(:store_membership))
        expect(Ability.new(admin_membership)).not_to be_able_to(:read, build(:store_membership))
        expect(Ability.new(owner_membership)).not_to be_able_to(:read, build(:store_membership))
      end
      it :cannot_update do
        expect(Ability.new(regular_membership)).not_to be_able_to(:update, build(:store_membership))
        expect(Ability.new(admin_membership)).not_to be_able_to(:update, build(:store_membership))
        expect(Ability.new(owner_membership)).not_to be_able_to(:update, build(:store_membership))
      end
      it :cannot_destroy do
        expect(Ability.new(regular_membership)).not_to be_able_to(:destroy, build(:store_membership))
        expect(Ability.new(admin_membership)).not_to be_able_to(:destroy, build(:store_membership))
        expect(Ability.new(owner_membership)).not_to be_able_to(:destroy, build(:store_membership))
      end
    end
  end

  describe 'scopes' do
    before do
      create(:store_membership, role: :regular)
      create(:store_membership, role: :admin)
      create(:store_membership, role: :owner)
    end

    it :has_regular_scope do
      expect(StoreMembership.regular.size).to eq(3)
    end

    it :has_admin_scope do
      expect(StoreMembership.admin.size).to eq(2)
    end

    it :has_owner_scope do
      expect(StoreMembership.owner.size).to eq(1)
    end
  end
end
