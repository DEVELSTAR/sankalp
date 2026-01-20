module Admin
  class SankalpsController < BaseController
    before_action :set_sankalp, only: [ :show, :edit, :update, :destroy ]

    def index
      @sankalps = SankalpRecord.includes(:user, :category).order(created_at: :desc)

      @sankalps = @sankalps.by_status(params[:status]) if params[:status].present?
      @sankalps = @sankalps.by_category(params[:category_id]) if params[:category_id].present?

      @pagy, @sankalps = pagy(@sankalps, limit: 20)
      @categories = Category.ordered
    end

    def show
      @daily_activities = @sankalp.daily_activities.order(activity_date: :desc)
      @pagy, @daily_activities = pagy(@daily_activities, limit: 15)
    end

    def edit
      @categories = Category.ordered
    end

    def update
      if @sankalp.update(sankalp_params)
        redirect_to admin_sankalp_path(@sankalp), notice: "Sankalp was successfully updated."
      else
        @categories = Category.ordered
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sankalp.destroy
      redirect_to admin_sankalps_path, notice: "Sankalp was successfully deleted."
    end

    private

    def set_sankalp
      @sankalp = SankalpRecord.find(params[:id])
    end

    def sankalp_params
      params.require(:sankalp).permit(:title, :description, :category_id, :start_date, :end_date, :status)
    end
  end
end
