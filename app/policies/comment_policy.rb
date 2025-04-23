class CommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
    def update?
     verify_user
    end

    def destroy?
     verify_user
    end

    private

    def verify_user
      user&.is_admin? || user&.id == record.user_id
    end
end
