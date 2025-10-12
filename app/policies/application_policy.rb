# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def store_owner?
    user.store_owner?(record.store)
  end

  def store_admin?
    user.store_admin?(record.store)
  end

  def store_user?
    user.store_user?(record.store)
  end

  def no?
    false
  end

  alias show? no?
  alias create? no?
  alias update? no?
  alias destroy? no?

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end

    private

    attr_reader :user, :scope
  end
end
