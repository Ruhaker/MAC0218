class FixCpfRange < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :cpf, :bigint
  end
end
