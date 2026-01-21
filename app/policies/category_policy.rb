class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    admin? || record.user_id == user.id
  end

  def destroy?
    admin? || record.user_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
