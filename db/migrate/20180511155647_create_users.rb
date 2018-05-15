class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :pw_hash
      t.string :pw_salt
      t.string :type

      t.timestamps
    end
    add_column :student_id, :integer
    add_index :users, :email, unique: true
  end
end
