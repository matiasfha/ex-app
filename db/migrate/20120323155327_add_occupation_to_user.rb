class AddOccupationToUser < ActiveRecord::Migration
  def change
    add_column :users, :occupation, :string, :default => ''

  end
end
