class Enrollment < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :course
  has_many :grades, dependent: :destroy

  validates :student_id, uniqueness: { scope: :course_id }

  def overall_grade
    grades.includes(:assessment_item).sum { |g| g.score * g.assessment_item.weight }.round(2)
  end
end
