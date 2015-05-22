class CreateInfoCivils < ActiveRecord::Migration
  def change
    create_table :info_civils do |t|
      t.references :case, index: true

      t.timestamps null: false
    end
    add_foreign_key :info_civils, :cases
  end
end
