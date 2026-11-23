class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
