class WelcomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @semesters = Course.last_semesters(5)
    @courses = Course.where(semester: @semesters).includes(:enrollments).sort_by do |course|
      year, season = Course.semester_sort_key(course.semester)
      [ -year, -season, course.code ]
    end
  end
end
