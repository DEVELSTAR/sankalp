class SankalpsController < ApplicationController
  before_action :set_sankalp, only: [ :show, :edit, :update, :destroy ]

  def index
    @sankalps = policy_scope(SankalpRecord)
                .includes(:category, :user)
                .order(created_at: :desc)

    @sankalps = @sankalps.by_status(params[:status]) if params[:status].present?
    @sankalps = @sankalps.by_category(params[:category_id]) if params[:category_id].present?

    @pagy, @sankalps = pagy(@sankalps, items: 12)
    @categories = Category.ordered
  end

  def show
    authorize @sankalp
    @daily_activities = @sankalp.daily_activities.order(activity_date: :desc)
    @pagy, @daily_activities = pagy(@daily_activities, items: 10)
  end

  def new
    @sankalp = current_user.sankalps.build
    @categories = Category.ordered
  end

  def create
    @sankalp = current_user.sankalps.build(sankalp_params)
    authorize @sankalp

    if @sankalp.save
      redirect_to @sankalp, notice: "Sankalp was successfully created."
    else
      @categories = Category.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @sankalp
    @categories = Category.ordered
  end

  def update
    authorize @sankalp

    if @sankalp.update(sankalp_params)
      notice = if @sankalp.saved_change_to_status? && @sankalp.completed?
        "Congratulations! You completed this Sankalp! Check your profile for a reward."
      else
        "Sankalp was successfully updated."
      end
      redirect_to @sankalp, notice: notice
    else
      @categories = Category.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @sankalp
    @sankalp.destroy
    redirect_to sankalps_path, notice: "Sankalp was successfully deleted."
  end

  private

  def set_sankalp
    @sankalp = SankalpRecord.find(params[:id])
  end

  def sankalp_params
    params.require(:sankalp).permit(:title, :description, :category_id, :start_date, :end_date, :status)
  end
end
