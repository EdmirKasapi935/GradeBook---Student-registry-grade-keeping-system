class AddUniqueIndexToCourses < ActiveRecord::Migration[8.1]
  def change
    add_index :courses, [ :code, :semester ], unique: true
  end
end
