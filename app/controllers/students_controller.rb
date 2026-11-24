class StudentsController < ApplicationController
  before_action :require_instructor
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @students = User.student.order(:surname, :name)
  end

  def show
  end

  def new
    @student = User.new
  end

  def edit
  end

  def create
    @student = User.new(student_params)
    @student.role = :student
    if @student.save
      redirect_to student_path(@student), notice: "Student was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student), notice: "Student was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: "Student was deleted."
  end

  private

  def set_student
    @student = User.student.find(params.expect(:id))
  end

  def student_params
    params.expect(user: [ :name, :surname, :email_address, :password, :password_confirmation ])
  end
end
