class AddVisualizingColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :visualizing, :boolean
  end
end
