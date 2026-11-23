instructor = User.find_or_create_by!(email_address: "instructor@uni.edu") do |u|
  u.name = "Ada"
  u.surname = "Lovelace"
  u.password = "Password1"
  u.role = :instructor
end

student = User.find_or_create_by!(email_address: "student@uni.edu") do |u|
  u.name = "Alan"
  u.surname = "Turing"
  u.password = "Password1"
  u.role = :student
end

cs101 = Course.find_or_create_by!(code: "CS101", semester: "Fall 2025") do |c|
  c.name = "Introduction to Programming"
  c.instructor = instructor
end

cs201 = Course.find_or_create_by!(code: "CS201", semester: "Fall 2025") do |c|
  c.name = "Data Structures"
  c.instructor = instructor
end

Enrollment.find_or_create_by!(student: student, course: cs101)
Enrollment.find_or_create_by!(student: student, course: cs201)
