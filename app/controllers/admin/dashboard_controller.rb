module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_sankalps = SankalpRecord.count
      @active_sankalps = SankalpRecord.active.count
      @completed_sankalps = SankalpRecord.completed.count
      @paused_sankalps = SankalpRecord.paused.count
      @total_activities = DailyActivity.count
      @completed_activities = DailyActivity.completed.count

      @recent_users = User.ordered.limit(5)
      @recent_sankalps = SankalpRecord.includes(:user, :category).order(created_at: :desc).limit(5)

      @category_stats = Category.with_sankalp_count.ordered

      # Statistics for charts
      @sankalps_by_status = {
        "Active" => @active_sankalps,
        "Completed" => @completed_sankalps,
        "Paused" => @paused_sankalps
      }

      @activities_this_week = DailyActivity.this_week.group(:activity_date).count
    end
  end
end
