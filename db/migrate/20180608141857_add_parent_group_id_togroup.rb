class AddParentGroupIdTogroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :group_id, :integer
  end
end
