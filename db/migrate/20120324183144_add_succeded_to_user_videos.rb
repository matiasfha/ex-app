class AddSuccededToUserVideos < ActiveRecord::Migration
  def change
    add_column :user_videos, :succeded, :integer, :default => 0

  end
end
