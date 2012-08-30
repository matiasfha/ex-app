class AddTermaToUser < ActiveRecord::Migration
  def change
    add_column :users, :terms, :boolean, :default => false

  end
end
