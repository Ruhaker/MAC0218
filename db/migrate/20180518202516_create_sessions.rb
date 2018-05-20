class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :browser
      t.string :ip_address
      t.datetime :last_accessed

      t.timestamps
    end
  end
end
