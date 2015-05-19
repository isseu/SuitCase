class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    alias_action :create, :read, :update, :destroy, :to => :crud

    user ||= User.new

    if user.role? :guest
      can :read, [Case, Litigante]
    end
    if user.role? :secretary
      can [:read, :destroy], Notification, :user_id => user.id
      # Pueden agregar casos a otras personas y tambien nombres posibles
      can :crud, [CaseRecord, CaseUser, PossibleName]
      can :read, [Case, Litigante]
    end
    if user.role? :lawyer
      can [:read, :destroy], Notification, :user_id => user.id
      can :crud, [CaseRecord, CaseUser, PossibleName], :user_id => user.id
      can :read, [Case, Litigante]
    end
    if user.role? :admin
      can :manage, :all
    end
  end
end
