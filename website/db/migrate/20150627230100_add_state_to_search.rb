class AddStateToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :state, :boolean, :default => false
  end
end
