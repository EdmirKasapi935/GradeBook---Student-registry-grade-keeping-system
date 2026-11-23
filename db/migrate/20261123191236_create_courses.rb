class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.string :semester
      t.text :catalog_data
      t.references :instructor, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
