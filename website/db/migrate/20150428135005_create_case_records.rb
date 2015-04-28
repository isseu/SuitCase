class CreateCaseRecords < ActiveRecord::Migration
  def change
    create_table :case_records do |t|
      t.references :case, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :case_records, :cases
    add_foreign_key :case_records, :users
  end
end
