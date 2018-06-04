class AddGroupsSubjectsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :groups_subjects do |t|
      t.integer :group_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
