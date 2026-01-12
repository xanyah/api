# frozen_string_literal: true

module V2
  class BaseController < ActionController::API
    include Pagy::Method
    include Pundit::Authorization
    include DoorkeeperUserConcern

    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound do
      head :not_found
    end

    rescue_from ArgumentError do |exception|
      render json: { errors: [exception] }, status: :unprocessable_content
    end

    rescue_from Pundit::NotAuthorizedError do |e|
      Rails.logger.error(e)
      head :unauthorized
    end
  end
end
