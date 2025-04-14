class UserPolicy < ApplicationPolicy

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

    def index?
      verify_is_admin
    end
    def show?
      verify_is_admin
    end

    def create?
      verify_is_admin 
    end

    def update?
      verify_is_admin 
    end

    def destroy?
      verify_is_admin 
    end

    private

    def verify_is_admin
      user&.is_admin? 
    end

end
