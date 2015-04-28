class CreatePossibleNames < ActiveRecord::Migration
  def change
    create_table :possible_names do |t|
      t.references :user, index: true
      t.string :name
      t.string :first_lastname
      t.string :second_lastname

      t.timestamps null: false
    end
    add_foreign_key :possible_names, :users
  end
end
