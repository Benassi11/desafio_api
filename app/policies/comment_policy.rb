class CommentPolicy < ApplicationPolicy
  
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
    def update?
      user&.is_admin? || user&.id == record.user_id
    end

    def destroy?
      user&.is_admin? || user&.id == record.user_id
    end
end

