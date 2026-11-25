puts "Seeding database..."

PASSWORD = "Password1"

# --- Instructors ---------------------------------------------------------
instructor_data = [
  [ "Ada", "Lovelace", "instructor@uni.edu" ],
  [ "Edsger", "Dijkstra", "dijkstra@uni.edu" ]
]

instructors = instructor_data.map do |name, surname, email|
  User.find_or_create_by!(email_address: email) do |u|
    u.name = name
    u.surname = surname
    u.password = PASSWORD
    u.role = :instructor
  end
end

# --- Students ------------------------------------------------------------
student_data = [
  [ "Alan", "Turing" ], [ "Grace", "Hopper" ], [ "Linus", "Torvalds" ],
  [ "Margaret", "Hamilton" ], [ "Tim", "Berners-Lee" ], [ "Barbara", "Liskov" ],
  [ "Dennis", "Ritchie" ], [ "Katherine", "Johnson" ], [ "Ken", "Thompson" ],
  [ "Radia", "Perlman" ]
]

students = student_data.each_with_index.map do |(name, surname), index|
  email = index.zero? ? "student@uni.edu" : "#{name.downcase}.#{surname.downcase}@uni.edu"
  User.find_or_create_by!(email_address: email) do |u|
    u.name = name
    u.surname = surname
    u.password = PASSWORD
    u.role = :student
  end
end

# --- Courses -------------------------------------------------------------
# [code, name, semester, instructor index]
course_data = [
  [ "CS101", "Introduction to Programming", "Spr 2024", 0 ],
  [ "MA201", "Discrete Mathematics",         "Fall 2024", 1 ],
  [ "CS201", "Data Structures",              "Spr 2025", 0 ],
  [ "CS210", "Computer Architecture",        "Spr 2025", 1 ],
  [ "CS305", "Databases",                    "Fall 2025", 0 ],
  [ "CS101", "Introduction to Programming", "Fall 2025", 0 ],
  [ "CS340", "Web Development",              "Spr 2026", 0 ],
  [ "MA210", "Probability and Statistics",   "Spr 2026", 1 ],
  [ "CS350", "Software Engineering",         "Fall 2026", 0 ],
  [ "CS360", "Artificial Intelligence",      "Fall 2026", 1 ]
]

# Two assessment schemes, both adding up to 100%
schemes = [
  [ [ "Midterm", 0.25 ], [ "Project", 0.35 ], [ "Final Exam", 0.40 ] ],
  [ [ "Assignment 1", 0.15 ], [ "Assignment 2", 0.15 ], [ "Midterm", 0.30 ], [ "Final Exam", 0.40 ] ]
]

current_semester = "Fall 2026"
rng = Random.new(2026) # fixed seed, so every run gives the same "random" grades

course_data.each_with_index do |(code, name, semester, instructor_index), index|
  course = Course.find_or_create_by!(code: code, semester: semester) do |c|
    c.name = name
    c.instructor = instructors[instructor_index]
    c.catalog_data = "#{name} offered in #{semester}."
  end

  items = schemes[index % 2].map do |title, weight|
    course.assessment_items.find_or_create_by!(title: title) { |a| a.weight = weight }
  end

  # 5 random students per course, and Alan is always in the even-numbered ones
  picked = students.sample(5, random: rng)
  picked |= [ students.first ] if index.even?

  picked.each do |student|
    enrollment = course.enrollments.find_or_create_by!(student: student)

    items.each do |item|
      # The current semester isn't over yet, so no final exam grades
      next if semester == current_semester && item.title == "Final Exam"

      enrollment.grades.find_or_create_by!(assessment_item: item) do |g|
        g.score = rng.rand(55..100)
      end
    end
  end
end

puts "Done!"
puts "  Instructors: #{User.instructor.count}"
puts "  Students:    #{User.student.count}"
puts "  Courses:     #{Course.count}"
puts "  Enrollments: #{Enrollment.count}"
puts "  Grades:      #{Grade.count}"
puts "All passwords: #{PASSWORD}"
