class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
   has_many :assessment_items, dependent: :destroy

  validates :code, :name, :semester, presence: true

  def total_weight
    assessment_items.sum(:weight)
  end

  def weights_complete?
    (total_weight - 1.0).abs < 0.001
  end
end
