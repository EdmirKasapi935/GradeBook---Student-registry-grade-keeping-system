class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :assessment_items, dependent: :destroy

  SEASONS = %w[Spr Sum Fall].freeze
  SEMESTER_FORMAT = /\A(Spr|Sum|Fall) \d{4}\z/

  normalizes :code, with: ->(c) { c.strip.upcase }
  normalizes :semester, with: ->(s) { season, year = s.strip.split; "#{season.to_s.capitalize} #{year}" }

  validates :code, presence: true, length: { in: 5..6 },
            uniqueness: { scope: :semester, message: "already exists in this semester" }
  validates :name, presence: true, length: { maximum: 50 }
  validates :semester, presence: true, length: { maximum: 10 },
          format: { with: SEMESTER_FORMAT, message: "must look like Spr 2026, Sum 2026 or Fall 2026" }
  validates :catalog_data, length: { maximum: 500 }, allow_blank: true

  def total_weight
    assessment_items.sum(:weight)
  end

  def weights_complete?
    (total_weight - 1.0).abs < 0.001
  end

  def self.semester_options
    this_year = Date.current.year
    (this_year - 5..this_year + 1).to_a.reverse.flat_map do |year|
      SEASONS.reverse.map { |season| "#{season} #{year}" }
    end
  end

  def self.semester_sort_key(semester)
    season, year = semester.to_s.split
    [ year.to_i, SEASONS.index(season.to_s.capitalize).to_i ]
  end

  def self.last_semesters(count = 5)
    distinct.pluck(:semester).sort_by { |s| semester_sort_key(s) }.last(count).reverse
  end

  def grade_statistics
    overall_grades = enrollments.select { |e| e.grades.any? }.map(&:overall_grade)
    return nil if overall_grades.empty?

    count = overall_grades.size
    mean = overall_grades.sum / count.to_f
    variance = overall_grades.sum { |g| (g - mean)**2 } / count

    {
      count: count,
      min: overall_grades.min,
      max: overall_grades.max,
      mean: mean.round(2),
      std_dev: Math.sqrt(variance).round(2)
    }
  end
end
