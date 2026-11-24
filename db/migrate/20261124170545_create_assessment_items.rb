class CreateAssessmentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :assessment_items do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title
      t.float :weight

      t.timestamps
    end
  end
end
