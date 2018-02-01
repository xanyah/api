# frozen_string_literal: true

class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: :not_found
  end

  rescue_from ArgumentError do |exception|
    render json: {errors: [exception]}, status: :unprocessable_entity
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: {errors: [exception]}, status: :unauthorized
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[firstname lastname email locale])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[firstname lastname locale])
  end
end
