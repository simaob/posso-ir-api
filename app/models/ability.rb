# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    return if user.user?

    if user.admin?
      can :manage, :all
    elsif user.general_manager?
      can [:new, :create], Store
      can :read, :all
    elsif user.store_manager?
      can :index, :manage_stores
      can [:new, :create], StatusStoreOwner
      can :read, :map
    end
  end
end
