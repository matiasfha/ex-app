class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :name
      t.integer :sex_id
      t.date :birthdate
      t.text :description

      t.timestamps
    end
  end
end
