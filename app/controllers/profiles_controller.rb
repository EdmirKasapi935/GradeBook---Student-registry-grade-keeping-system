class ProfilesController < ApplicationController
  before_action :require_instructor
  before_action :set_user

  def edit
  end

  def update
    if @user.update(params.expect(user: [ :name, :surname, :email_address ]))
      redirect_to edit_profile_path, notice: "Your personal info was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def update_password
    password_params = params.expect(user: [ :password_challenge, :password, :password_confirmation ])

    if password_params[:password].blank?
      @user.errors.add(:password, "can't be blank")
      render :edit, status: :unprocessable_content
    elsif @user.update(password_params)
      redirect_to edit_profile_path, notice: "Your password was changed."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = Current.user
  end
end
