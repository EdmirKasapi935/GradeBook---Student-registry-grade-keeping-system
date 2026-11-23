class WelcomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @courses = Course.includes(:enrollments).order(semester: :desc, code: :asc)
  end
end
