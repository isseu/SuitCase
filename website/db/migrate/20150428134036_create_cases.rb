class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :rol
      t.datetime :fecha
      t.string :tribunal
      t.text :caratula
      t.integer :info_id
      t.string :info_type

      t.timestamps null: false
    end
  end
end
