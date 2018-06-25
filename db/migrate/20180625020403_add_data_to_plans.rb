class AddDataToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :start_year, :integer
    add_column :plans, :status, :string
  end
end
