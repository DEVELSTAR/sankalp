module Admin
  class UsersController < BaseController
    before_action :set_user, only: [ :show, :edit, :update, :destroy ]

    def index
      @users = User.ordered
      @pagy, @users = pagy(@users, items: 20)
    end

    def show
      @sankalps = @user.sankalps.includes(:category).order(created_at: :desc)
      @categories = @user.categories.ordered
      @activities = @user.daily_activities.includes(sankalp: :category).order(activity_date: :desc).limit(10)
      @rewards = @user.rewards.includes(:sankalp).order(created_at: :desc).limit(5)
      @pagy, @sankalps = pagy(@sankalps, items: 10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete your own account."
      else
        # Handle cascading deletes explicitly
        ActiveRecord::Base.transaction do
          # Soft delete sankalps (uses paranoia)
          @user.sankalps.each(&:destroy)

          # Hard delete other associations
          @user.sankalp_assignments.destroy_all
          @user.categories.destroy_all
          @user.rewards.destroy_all

          # Now delete the user
          @user.destroy
        end

        redirect_to admin_users_path, notice: "User was successfully deleted."
      end
    rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::InvalidForeignKey => e
      redirect_to admin_users_path, alert: "Failed to delete user: #{e.message}"
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :role)
    end
  end
end
