class EnrollmentsController < ApplicationController
  before_action :require_instructor
  before_action :set_course

  def index
    @enrollments = @course.enrollments.includes(:student).joins(:student).order("users.surname, users.name")
    @available_students = User.student.where.not(id: @course.student_ids).order(:surname, :name)
  end

  def create
    student = User.student.find_by(id: params[:student_id])

    if student && @course.enrollments.create(student: student).persisted?
      redirect_to course_enrollments_path(@course), notice: "#{student.full_name} was added to the course."
    else
      redirect_to course_enrollments_path(@course), alert: "Could not add the student. Please pick a student from the list."
    end
  end

  def destroy
    enrollment = @course.enrollments.find(params.expect(:id))
    enrollment.destroy
    redirect_to course_enrollments_path(@course), notice: "Student was removed from the course."
  end

  private

  def set_course
    @course = Current.user.taught_courses.find(params.expect(:course_id))
  end
end
