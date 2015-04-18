class AddDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rut, :string, null: false, default: ''
    add_column :users, :name, :string,  null: false, default: ''
    add_column :users, :first_lastname, :string, null: false, default: ''
    add_column :users, :second_lastname, :string, null: false, default: ''
    add_column :users, :password_judicial, :string
    add_column :users, :telephone, :string
  end
end
