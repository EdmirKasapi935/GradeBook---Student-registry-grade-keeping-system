class Grade < ApplicationRecord
  belongs_to :enrollment
  belongs_to :assessment_item

  validates :score, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 120 }
  validates :assessment_item_id, uniqueness: { scope: :enrollment_id, message: "already has a grade for this student" }
  validate :assessment_item_belongs_to_same_course

  private

  def assessment_item_belongs_to_same_course
    return if enrollment.nil? || assessment_item.nil?
    if assessment_item.course_id != enrollment.course_id
      errors.add(:assessment_item, "does not belong to this course")
    end
  end
end
