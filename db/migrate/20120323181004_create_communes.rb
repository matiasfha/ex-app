class CreateCommunes < ActiveRecord::Migration
  def change
    create_table :communes do |t|
      t.string :name

      t.timestamps
    end
  end
end
