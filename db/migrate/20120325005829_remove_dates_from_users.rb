class RemoveDatesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :birthdate
      end

  def down
    add_column :users, :birthdate, :date
  end
end
