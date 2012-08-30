class AddCommuneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :commune_id, :integer

  end
end
