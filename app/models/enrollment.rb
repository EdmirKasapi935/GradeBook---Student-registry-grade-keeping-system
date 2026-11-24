class Enrollment < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :course

  validates :student_id, uniqueness: { scope: :course_id }
end
