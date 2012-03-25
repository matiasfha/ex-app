class RemoveUserIdFromVideo < ActiveRecord::Migration
  def up
    remove_column :videos, :user_id
      end

  def down
    add_column :videos, :user_id, :integer
  end
end
