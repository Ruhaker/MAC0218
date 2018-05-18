class CreateSupervisors < ActiveRecord::Migration[5.1]
  def change
    create_table :supervisors do |t|
      t.integer :cpf

      t.timestamps
    end
  end
end
