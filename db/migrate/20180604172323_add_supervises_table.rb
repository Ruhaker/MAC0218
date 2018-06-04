class AddSupervisesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :supervises do |t|
      t.integer :course_id
      t.integer :supervisor_id

      t.timestamps
    end
  end
end
