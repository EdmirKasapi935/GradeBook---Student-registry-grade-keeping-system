class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  EDITABLE_FIELDS = %i[name surname email_address password password_confirmation].freeze

  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
  PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :name, :surname, presence: true, length: { maximum: 30 }
  validates :email_address, presence: true, uniqueness: true,
            format: { with: VALID_EMAIL_REGEX, message: "is not a valid email address" }
  validates :password, length: { minimum: 8 },
            format: { with: PASSWORD_REGEX, message: "must contain at least one uppercase letter, one lowercase letter and one number" },
            allow_nil: true
  validate :full_name_not_too_long

  enum :role, { instructor: 0, student: 1 }

  has_many :taught_courses, class_name: "Course", foreign_key: :instructor_id, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :courses, through: :enrollments

  def full_name
    "#{name} #{surname}"
  end

  def transcript(start_semester = nil, end_semester = nil)
    from = start_semester.present? ? Course.semester_sort_key(start_semester) : nil
    to = end_semester.present? ? Course.semester_sort_key(end_semester) : nil

    in_range = enrollments.includes(:course).select do |enrollment|
      key = Course.semester_sort_key(enrollment.course.semester)
      (from.nil? || (key <=> from) >= 0) && (to.nil? || (key <=> to) <= 0)
    end

    by_semester = in_range.sort_by { |e| Course.semester_sort_key(e.course.semester) }
                          .group_by { |e| e.course.semester }

    {
      student: as_json,
      semesters: by_semester.map do |semester, semester_enrollments|
        {
          semester: semester,
          courses: semester_enrollments.map do |e|
            { code: e.course.code, name: e.course.name, overall_grade: e.overall_grade }
          end
        }
      end
    }
  end

  def as_json(options = {})
    super({ only: %i[id name surname email_address role] }.merge(options))
  end

  private

  def full_name_not_too_long
    if name.to_s.length + surname.to_s.length > 50
      errors.add(:base, "Name and surname together must not exceed 50 characters")
    end
  end
end
