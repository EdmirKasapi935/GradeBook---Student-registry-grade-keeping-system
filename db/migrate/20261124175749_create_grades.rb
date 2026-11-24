class CreateGrades < ActiveRecord::Migration[8.1]
  def change
    create_table :grades do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.references :assessment_item, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end

    add_index :grades, [ :enrollment_id, :assessment_item_id ], unique: true
  end
end
