class CreateInfoCortes < ActiveRecord::Migration
  def change
    create_table :info_cortes do |t|
      t.references :case, index: true
      t.string :numero_ingreso
      t.string :ubicacion
      t.string :corte
      t.date :fecha_ubicacion

      t.timestamps null: false
    end
    add_foreign_key :info_cortes, :cases
  end
end
