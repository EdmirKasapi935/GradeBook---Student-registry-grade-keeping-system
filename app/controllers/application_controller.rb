class ApplicationController < ActionController::Base
  include Authentication
  include Paginatable
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :duplicate_record
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def require_instructor
    redirect_to root_path, alert: "You are not authorized to view that page." unless Current.user&.instructor?
  end

  def require_student
    redirect_to root_path, alert: "You are not authorized to view that page." unless Current.user&.student?
  end

  def redirect_if_authenticated
    redirect_to after_authentication_url, notice: "You are already logged in." if authenticated?
  end

  def record_not_found
    redirect_to home_path, alert: "Sorry, we couldn't find what you were looking for."
  end

  def duplicate_record
    redirect_to home_path, alert: "That record already exists."
  end

  def bad_request
    redirect_to home_path, alert: "Something was missing from your request. Please try again."
  end

  def home_path
    authenticated? ? after_authentication_url : root_path
  end

  stale_when_importmap_changes
end
