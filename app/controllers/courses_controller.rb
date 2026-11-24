class CoursesController < ApplicationController
  before_action :require_instructor
  before_action :set_course, only: %i[show edit update destroy]

  def index
    @courses = Current.user.taught_courses.includes(:enrollments).order(semester: :desc, code: :asc)
  end

  def show
  end

  def new
    @course = Current.user.taught_courses.new
  end

  def edit
  end

  def create
    @course = Current.user.taught_courses.new(course_params)
    if @course.save
      redirect_to @course, notice: "Course was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: "Course was deleted."
  end

  private

  def set_course
    @course = Current.user.taught_courses.find(params.expect(:id))
  end

  def course_params
    params.expect(course: [ :code, :name, :semester, :catalog_data ])
  end
end
