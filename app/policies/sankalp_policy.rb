class SankalpPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin? || owner?
  end

  def create?
    user.present?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
