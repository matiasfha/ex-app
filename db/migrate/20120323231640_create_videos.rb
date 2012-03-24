class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.text :description
      t.integer :length
      t.integer :character_duration
      t.string :correct_keyword
      t.text :keywords

      t.timestamps
    end
  end
end
