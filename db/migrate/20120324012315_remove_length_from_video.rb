class RemoveLengthFromVideo < ActiveRecord::Migration
  def up
    remove_column :videos, :length
      end

  def down
    add_column :videos, :length, :integer
  end
end
