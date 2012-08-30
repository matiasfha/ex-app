class CreateExperimentVideos < ActiveRecord::Migration
  def change
    create_table :experiment_videos do |t|
      t.integer :video_id
      t.integer :experiment_id
      t.date :play_date

      t.timestamps
    end
  end
end
