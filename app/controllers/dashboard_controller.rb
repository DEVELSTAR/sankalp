class DashboardController < ApplicationController
  before_action :redirect_admin_if_needed

  def index
    @active_sankalps = current_user.sankalps.active.includes(:category).order(created_at: :desc).limit(5)
    @today_pending = pending_activities_for_today
    @total_sankalps = current_user.sankalps.count
    @completed_sankalps = current_user.sankalps.completed.count
    @total_activities = current_user.daily_activities.count
    @completed_activities = current_user.daily_activities.completed.count
    @recent_activities = current_user.daily_activities
                                      .includes(sankalp: :category)
                                      .order(activity_date: :desc)
                                      .limit(10)
  end

  private

  def redirect_admin_if_needed
    if current_user&.admin?
      redirect_to admin_root_path and return
    end
  end

  def pending_activities_for_today
    current_user.sankalps.active.includes(:category).select do |sankalp|
      activity = sankalp.daily_activities.find_by(activity_date: Date.current)
      activity.nil? || !activity.completed?
    end
  end
end
