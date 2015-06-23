class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.string :first_lastname
      t.string :second_lastname
      t.string :rut
      t.string :rol

      t.timestamps null: false
    end
  end
end
