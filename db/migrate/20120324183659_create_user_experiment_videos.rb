class CreateUserExperimentVideos < ActiveRecord::Migration
  def change
    create_table :user_experiment_videos do |t|
      t.integer :experiment_id
      t.integer :user_id
      t.integer :video_id
      t.integer :succeded, :default => 0
      t.integer :attempts, :default => 0

      t.timestamps
    end
  end
end
