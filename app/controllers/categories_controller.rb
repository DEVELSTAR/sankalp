class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @categories = Category.accessible_by_user(current_user).with_sankalp_count.ordered
  end

  def show
    authorize @category
    @sankalps = @category.sankalps.includes(:user).order(created_at: :desc)
    @pagy, @sankalps = pagy(@sankalps, items: 12)
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    authorize @category

    if @category.save
      redirect_to categories_path, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @category
  end

  def update
    authorize @category

    if @category.update(category_params)
      redirect_to categories_path, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @category

    if @category.destroy
      redirect_to categories_path, notice: "Category was successfully deleted."
    else
      redirect_to categories_path, alert: @category.errors.full_messages.join(", ")
    end
  end

  private

  def set_category
    @category = Category.accessible_by_user(current_user).find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :color, :icon)
  end
end
