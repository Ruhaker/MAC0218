class AddSessionColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :sessions, :session_key, :string
    add_column :sessions, :active, :boolean
  end
end
