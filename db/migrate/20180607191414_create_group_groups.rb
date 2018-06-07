class CreateGroupGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :group_groups do |t|
      t.integer :group_id
      t.timestamps
    end
  end
end
