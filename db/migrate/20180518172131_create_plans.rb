class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.integer :course_id
      t.integer :student_id
      t.integer :group_id
      t.timestamps
    end
  end
end
