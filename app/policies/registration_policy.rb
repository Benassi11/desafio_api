class RegistrationsPolicy < ApplicationPolicy

    class Scope < ApplicationPolicy::Scope
      # NOTE: Be explicit about which records you allow access to!
      # def resolve
      #   scope.all
      # end
    end
  
    def create?
        user&.is_admin? 
    end

  end
  