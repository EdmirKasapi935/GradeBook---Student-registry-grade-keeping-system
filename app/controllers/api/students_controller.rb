module Api
  class StudentsController < BaseController
    before_action :require_api_instructor, except: :transcript
    before_action :set_student, only: %i[show update destroy transcript]

    def index
      render json: User.student.order(:surname, :name)
    end

    def show
      render json: @student
    end

    def create
      student = User.new(student_params)
      student.role = :student
      if student.save
        render json: student, status: :created
      else
        render json: { errors: student.errors.full_messages }, status: :unprocessable_content
      end
    end

    def update
      if @student.update(student_params)
        render json: @student
      else
        render json: { errors: @student.errors.full_messages }, status: :unprocessable_content
      end
    end

    def destroy
      @student.destroy
      head :no_content
    end

    def transcript
      unless @current_user.instructor? || @current_user == @student
        return render json: { error: "You can only view your own transcript" }, status: :forbidden
      end

      render json: @student.transcript(params[:start_semester], params[:end_semester])
    end

    private

    def set_student
      @student = User.student.find(params.expect(:id))
    end

    def student_params
      params.expect(student: User::EDITABLE_FIELDS)
    end
  end
end
