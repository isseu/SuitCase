class CreateInfoSupremas < ActiveRecord::Migration
  def change
    create_table :info_supremas do |t|
      t.references :case, index: true
      t.string :numero_ingreso
      t.string :tipo_recurso
      t.string :ubicacion
      t.string :corte
      t.date :fecha_ubicacion

      t.timestamps null: false
    end
    add_foreign_key :info_supremas, :cases
  end
end
