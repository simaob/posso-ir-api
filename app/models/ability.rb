# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    return if user.user?

    can [:show, :edit, :update], User, id: user.id
    can :read, :map

    if user.admin?
      can :manage, :all

    elsif user.general_manager?
      can [:new, :create, :edit, :update], Store
      can [:new, :create], User

      can [:edit, :update], User do |usr|
        usr == user || !usr.admin?
      end

      can :manage_state, Store
      can :read, :all

    elsif user.contributor?
      can [:new, :create], Store do |store|
        user.email.present?
      end
      can [:edit, :update], Store do |store|
        store.created_by_id == user.id && store.source == 'Community' && user.email.present?
      end
      can :read, Store

    elsif user.store_owner?
      can :index, :manage_stores
      can [:show, :edit, :update], Store do |store|
        store.manager_ids.include?(user.id)
      end
      can [:new, :create], StatusStoreOwner do |sso|
        user.store_ids.include?(sso.store_id)
      end
      can :manage, Phone do |phone|
        user.store_ids.include?(phone.store_id)
      end
    end
  end
end
