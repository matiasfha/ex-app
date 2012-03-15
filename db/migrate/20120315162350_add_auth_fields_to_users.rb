class AddAuthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referal, :string

    add_column :users, :active, :boolean

    add_column :users, :random_pass, :string

    add_column :users, :image, :string

  end
end
