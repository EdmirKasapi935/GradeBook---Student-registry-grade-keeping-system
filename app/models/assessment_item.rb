class AssessmentItem < ApplicationRecord
  belongs_to :course

  validates :title, :weight, presence: true
  validates :title, uniqueness: { scope: :course_id }
  validates :weight, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
end
