module Api
  class BaseController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    before_action :authenticate_api_user

    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: "Record not found" }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { error: e.message }, status: :bad_request
    end

    private

    def authenticate_api_user
      @current_user = authenticate_with_http_basic do |email, password|
        User.authenticate_by(email_address: email, password: password)
      end
      render json: { error: "Invalid email or password" }, status: :unauthorized unless @current_user
    end

    def require_api_instructor
      return if @current_user.instructor?
      render json: { error: "Only instructors can do this" }, status: :forbidden
    end
  end
end
