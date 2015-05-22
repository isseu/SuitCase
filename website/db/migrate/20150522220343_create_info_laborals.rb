class CreateInfoLaborals < ActiveRecord::Migration
  def change
    create_table :info_laborals do |t|
      t.references :case, index: true
      t.string :rit
      t.string :ruc

      t.timestamps null: false
    end
    add_foreign_key :info_laborals, :cases
  end
end
