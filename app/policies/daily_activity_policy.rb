class DailyActivityPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin? || owner?
  end

  def create?
    admin? || sankalp_owner?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  def toggle?
    admin? || owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:sankalp).where(sankalps: { user_id: user.id })
      end
    end
  end

  private

  def admin?
    user&.admin?
  end

  def owner?
    record.sankalp.user == user
  end

  def sankalp_owner?
    record.sankalp.user == user
  end
end
