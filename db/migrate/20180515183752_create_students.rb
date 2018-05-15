class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.integer :nusp
      t.integer :user_id

      t.timestamps
    end
  end
end
