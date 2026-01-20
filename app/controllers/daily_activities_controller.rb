class DailyActivitiesController < ApplicationController
  before_action :set_sankalp
  before_action :set_daily_activity, only: [ :show, :edit, :update, :destroy, :toggle ]

  def index
    @daily_activities = policy_scope(@sankalp.daily_activities)
                        .order(activity_date: :desc)
    @pagy, @daily_activities = pagy(@daily_activities, limit: 15)
  end

  def show
    authorize @daily_activity
  end

  def new
    @daily_activity = @sankalp.daily_activities.build(activity_date: Date.current)
  end

  def create
    @daily_activity = @sankalp.daily_activities.build(daily_activity_params)
    authorize @daily_activity

    if @daily_activity.save
      redirect_to @sankalp, notice: "Activity logged successfully."
    else
      # Check if validation failed due to existing activity for date
      existing = @sankalp.daily_activities.find_by(activity_date: @daily_activity.activity_date)

      if existing
        @daily_activity = existing
        @daily_activity.assign_attributes(daily_activity_params)
        flash.now[:notice] = "An activity already exists for this date. You are now updating it."
        render :edit, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    authorize @daily_activity
  end

  def update
    authorize @daily_activity

    if @daily_activity.update(daily_activity_params)
      redirect_to @sankalp, notice: "Activity updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @daily_activity
    @daily_activity.destroy

    respond_to do |format|
      format.html { redirect_to @sankalp, notice: "Activity deleted successfully." }
      format.turbo_stream
    end
  end

  def toggle
    authorize @daily_activity
    @daily_activity.toggle_completion!

    respond_to do |format|
      format.html { redirect_to @sankalp, notice: "Activity status updated." }
      format.turbo_stream { render :toggle }
    end
  end

  private

  def set_sankalp
    @sankalp = current_user.admin? ? SankalpRecord.find(params[:sankalp_id]) : current_user.sankalps.find(params[:sankalp_id])
  end

  def set_daily_activity
    @daily_activity = @sankalp.daily_activities.find(params[:id])
  end

  def daily_activity_params
    params.require(:daily_activity).permit(:activity_date, :notes, :completed)
  end
end
