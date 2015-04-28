class CreateCaseUsers < ActiveRecord::Migration
  def change
    create_table :case_users do |t|
      t.references :case, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :case_users, :cases
    add_foreign_key :case_users, :users
  end
end
