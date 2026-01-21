module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: [ :show, :edit, :update, :destroy ]

    def index
      @categories = Category.with_sankalp_count.ordered
    end

    def show
      @sankalps = @category.sankalps.includes(:user).order(created_at: :desc)
      @pagy, @sankalps = pagy(@sankalps, items: 15)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      @category.user = nil  # Admin categories are global

      if @category.save
        redirect_to admin_categories_path, notice: "Category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      sankalps_count = @category.sankalps.count

      if sankalps_count > 0
        redirect_to admin_categories_path,
                    alert: "Cannot delete category '#{@category.name}' because it has #{sankalps_count} associated #{'sankalp'.pluralize(sankalps_count)}."
      elsif @category.destroy
        redirect_to admin_categories_path, notice: "Category was successfully deleted."
      else
        redirect_to admin_categories_path, alert: @category.errors.full_messages.join(", ")
      end
    rescue ActiveRecord::InvalidForeignKey
      redirect_to admin_categories_path,
                  alert: "Cannot delete this category because it has associated records."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :color, :icon)
    end
  end
end
