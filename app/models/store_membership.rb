# frozen_string_literal: true

class StoreMembership < ApplicationRecord
  enum role: { regular: 0, admin: 1, owner: 2 }
  validates :store, uniqueness: { scope: :user }
  belongs_to :store, optional: false
  belongs_to :user, optional: false

  scope :regular, -> { where(role: %i[regular admin owner]) }
  scope :admin, -> { where(role: %i[admin owner]) }
  scope :owner, -> { where(role: :owner) }
end
