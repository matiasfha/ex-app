class AddVideoIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :video_id, :integer

  end
end
