class Grade < ApplicationRecord
  belongs_to :enrollment
  belongs_to :assessment_item

  validates :score, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 120 }
  validates :assessment_item_id, uniqueness: { scope: :enrollment_id, message: "already has a grade for this student" }
  validate :assessment_item_belongs_to_same_course

  def self.submit_entries(instructor, entries)
    errors = []
    saved_count = 0

    transaction do
      entries.each_with_index do |entry, index|
        error = submit_entry(instructor, entry)
        if error
          errors << { entry: index, error: error }
        else
          saved_count += 1
        end
      end
      raise ActiveRecord::Rollback if errors.any?
    end

    errors.any? ? { saved: 0, errors: errors } : { saved: saved_count, errors: [] }
  end

  def self.submit_entry(instructor, entry)
    course = instructor.taught_courses.find_by(code: entry[:course_code], semester: entry[:semester])
    return "Course #{entry[:course_code]} #{entry[:semester]} not found" unless course

    enrollment = course.enrollments.find_by(student_id: entry[:student_id])
    return "Student #{entry[:student_id]} is not enrolled in #{course.code}" unless enrollment

    item = course.assessment_items.find_by(title: entry[:assessment_title])
    return "Assessment '#{entry[:assessment_title]}' not found in #{course.code}" unless item

    grade = enrollment.grades.find_or_initialize_by(assessment_item: item)
    grade.score = entry[:grade]
    grade.save ? nil : grade.errors.full_messages.to_sentence
  end

  private

  def assessment_item_belongs_to_same_course
    return if enrollment.nil? || assessment_item.nil?
    if assessment_item.course_id != enrollment.course_id
      errors.add(:assessment_item, "does not belong to this course")
    end
  end
end
