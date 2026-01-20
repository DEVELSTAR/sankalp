class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Pagy pagination method for Pagy v43+
  def pagy(collection, vars = {})
    vars[:limit] ||= 20
    vars[:page] ||= params[:page]&.to_i || 1

    count = collection.count(:all)
    pagy = Pagy::Offset.new(count: count, **vars)

    [ pagy, collection.offset(pagy.offset).limit(pagy.limit) ]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name ])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end

  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end
end
