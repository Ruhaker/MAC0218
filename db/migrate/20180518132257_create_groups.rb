class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :min_credits
      t.integer :min_subjects

      t.timestamps
    end
  end
end
