class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

  private

  def admin?
    user&.admin?
  end

  def owner?
    record == user
  end
end
