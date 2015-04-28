class CreateClientUsers < ActiveRecord::Migration
  def change
    create_table :client_users do |t|
      t.references :user, index: true
      t.references :client, index: true

      t.timestamps null: false
    end
    add_foreign_key :client_users, :users
    add_foreign_key :client_users, :clients
  end
end
