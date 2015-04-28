class CreateLitigantes < ActiveRecord::Migration
  def change
    create_table :litigantes do |t|
      t.references :case, index: true
      t.string :participante
      t.string :rut
      t.string :persona
      t.string :nombre

      t.timestamps null: false
    end
    add_foreign_key :litigantes, :cases
  end
end
