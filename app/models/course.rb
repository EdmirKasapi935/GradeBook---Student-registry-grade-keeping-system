class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  validates :code, :name, :semester, presence: true
end
