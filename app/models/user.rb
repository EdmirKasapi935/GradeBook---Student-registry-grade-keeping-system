class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :name, :surname, :email_address, presence: true
  validates :email_address, uniqueness: true

  enum :role, { instructor: 0, student: 1 }
  has_many :taught_courses, class_name: "Course", foreign_key: :instructor_id, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :courses, through: :enrollments

  def full_name
    "#{name} #{surname}"
  end
end
