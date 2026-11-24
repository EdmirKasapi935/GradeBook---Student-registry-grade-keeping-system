class InstructorController < ApplicationController
  before_action :require_instructor

  def dashboard
    @course_count = Current.user.taught_courses.count
    @student_count = User.student.count
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to instructor_dashboard_path, notice: "Your personal info was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def profile_params
    params.expect(user: [ :name, :surname, :email_address, :password, :password_confirmation ])
  end
end
