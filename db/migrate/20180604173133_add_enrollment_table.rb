class AddEnrollmentTable < ActiveRecord::Migration[5.1]
  def change
    create_table :enrollment do |t|
      t.integer :course_id
      t.integer :student_id

      t.timestamps
    end
  end
end
