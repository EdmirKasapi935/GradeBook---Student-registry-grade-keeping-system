module Api
  class GradesController < BaseController
    before_action :require_api_instructor

    def create
      entries = params.expect(grades: [ [ :student_id, :course_code, :semester, :assessment_title, :grade ] ])
      result = Grade.submit_entries(@current_user, entries)

      if result[:errors].empty?
        render json: result, status: :created
      else
        render json: result, status: :unprocessable_content
      end
    end
  end
end
