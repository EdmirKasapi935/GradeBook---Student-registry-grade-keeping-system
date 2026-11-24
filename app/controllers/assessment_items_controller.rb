class AssessmentItemsController < ApplicationController
  before_action :require_instructor
  before_action :set_course
  before_action :set_assessment_item, only: %i[edit update destroy]

  def index
    @assessment_items = @course.assessment_items.order(:created_at)
  end

  def new
    @assessment_item = @course.assessment_items.new
  end

  def create
    @assessment_item = @course.assessment_items.new(assessment_item_params)
    if @assessment_item.save
      redirect_to course_assessment_items_path(@course), notice: "Assessment item was added."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @assessment_item.update(assessment_item_params)
      redirect_to course_assessment_items_path(@course), notice: "Assessment item was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @assessment_item.destroy
    redirect_to course_assessment_items_path(@course), notice: "Assessment item was deleted."
  end

  private

  def set_course
    @course = Current.user.taught_courses.find(params.expect(:course_id))
  end

  def set_assessment_item
    @assessment_item = @course.assessment_items.find(params.expect(:id))
  end

  def assessment_item_params
    params.expect(assessment_item: [ :title, :weight ])
  end
end
