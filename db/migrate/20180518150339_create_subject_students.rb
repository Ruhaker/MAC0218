class CreateSubjectStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :subject_students do |t|
      t.integer :subject_id
      t.integer :student_id
      t.integer :progress
      t.timestamps
    end
  end
end
