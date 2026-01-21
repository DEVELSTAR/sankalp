# frozen_string_literal: true

module CategoriesLoader
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories ||= Category.accessible_by_user(current_user).ordered
  end
end
