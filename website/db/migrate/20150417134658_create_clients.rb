class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :rut
      t.string :first_lastname
      t.string :second_lastname
      t.boolean :is_company, default: false

      t.timestamps null: false
    end
  end
end
