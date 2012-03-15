class CreateRefs < ActiveRecord::Migration
  def change
    create_table :refs do |t|
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end
