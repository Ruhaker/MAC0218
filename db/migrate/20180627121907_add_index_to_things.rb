class AddIndexToThings < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :index, :integer
  end
end
