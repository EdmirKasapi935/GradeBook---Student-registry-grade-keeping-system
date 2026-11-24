class StudentController < ApplicationController
   before_action :require_student

  def dashboard
    @enrollments = Current.user.enrollments.includes(:course).joins(:course)
                          .order("courses.semester DESC, courses.code ASC")
  end

  def course_grades
    @enrollment = Current.user.enrollments.find_by(course_id: params[:id])

    if @enrollment.nil?
      redirect_to student_dashboard_path, alert: "You are not enrolled in that course."
      return
    end

    @course = @enrollment.course
    @assessment_items = @course.assessment_items.order(:created_at)
    @grades_by_item = @enrollment.grades.index_by(&:assessment_item_id)
  end
end
