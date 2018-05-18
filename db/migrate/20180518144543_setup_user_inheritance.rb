class SetupUserInheritance < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nusp, :integer
    add_column :users, :cpf, :integer
    add_column :users, :type, :string
  end
end
