class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :code
      t.string :name
      t.integer :credits_class
      t.integer :credits_work
      t.integer :workload
      t.string :description

      t.timestamps
    end
  end
end
