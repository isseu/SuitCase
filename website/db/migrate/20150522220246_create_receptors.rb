class CreateReceptors < ActiveRecord::Migration
  def change
    create_table :receptors do |t|
      t.references :info_civil, index: true
      t.string :notebook
      t.string :dat
      t.string :state

      t.timestamps null: false
    end
    add_foreign_key :receptors, :info_civils
  end
end
