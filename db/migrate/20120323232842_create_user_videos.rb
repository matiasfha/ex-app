class CreateUserVideos < ActiveRecord::Migration
  def change
    create_table :user_videos do |t|
      t.integer :user_id
      t.integer :video_id
      t.boolean :seen, :default => false
      t.integer :attempts, :default => 0

      t.timestamps
    end
  end
end
