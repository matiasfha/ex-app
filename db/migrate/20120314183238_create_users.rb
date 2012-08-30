class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, :default => ''
      t.string :last_name, :default => ''
      t.string :email, :default => ''
      t.string :rut, :default => ''
      t.string :address, :default => ''
      t.string :password_hash, :default => ''
      t.string :password_salt, :default => ''
      t.integer :sex_id, :default => 3
      t.integer :city_id, :default => 1
      t.integer :country_id, :default => 1
      t.date :birthdate, :default => Time.now
      t.text :description, :default => ''
      t.string :random_pass, :default => ''
      t.string :referal, :default => ''
      t.string :image, :default => ''
      t.boolean :active, :default => false
      t.integer :marital_status_id, :default => 5

      t.timestamps
    end
  end
end
