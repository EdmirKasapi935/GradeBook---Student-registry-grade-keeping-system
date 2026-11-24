class GradesController < ApplicationController
  before_action :require_instructor
  before_action :set_course_and_enrollment
  before_action :set_grade, only: %i[edit update destroy]
  before_action :set_available_items, only: %i[new create]

  def index
    @grades = @enrollment.grades.includes(:assessment_item).order("assessment_items.created_at").references(:assessment_items)
  end

  def new
    @grade = @enrollment.grades.new
  end

  def create
    @grade = @enrollment.grades.new(grade_params)
    if @grade.save
      redirect_to course_enrollment_grades_path(@course, @enrollment), notice: "Grade was added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @grade.update(score: grade_params[:score])
      redirect_to course_enrollment_grades_path(@course, @enrollment), notice: "Grade was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @grade.destroy
    redirect_to course_enrollment_grades_path(@course, @enrollment), notice: "Grade was deleted."
  end

  private

  def set_course_and_enrollment
    @course = Current.user.taught_courses.find(params.expect(:course_id))
    @enrollment = @course.enrollments.find(params.expect(:enrollment_id))
  end

  def set_grade
    @grade = @enrollment.grades.find(params.expect(:id))
  end

  def set_available_items
    graded_ids = @enrollment.grades.pluck(:assessment_item_id)
    @available_items = @course.assessment_items.where.not(id: graded_ids).order(:created_at)
  end

  def grade_params
    params.expect(grade: [ :assessment_item_id, :score ])
  end
end
