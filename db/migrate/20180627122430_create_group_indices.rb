class CreateGroupIndices < ActiveRecord::Migration[5.1]
  def change
    create_table :group_indices do |t|
      t.references :subject, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :index
      t.timestamps
    end
  end
end
