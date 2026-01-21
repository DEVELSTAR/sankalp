module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_categories = Category.count
      
      @recent_users = User.ordered.limit(5)
      @categories = Category.with_sankalp_count.ordered
      
      # Current admin user profile data
      @admin_user = current_user
      @admin_sankalps = current_user.sankalps.includes(:category).order(created_at: :desc).limit(5)
      @admin_activities = current_user.daily_activities.includes(sankalp: :category).order(activity_date: :desc).limit(5)
      @admin_rewards = current_user.rewards.includes(:sankalp).order(created_at: :desc).limit(3)
    end
  end
end
