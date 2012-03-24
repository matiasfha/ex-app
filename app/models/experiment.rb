class Experiment < ActiveRecord::Base

	has_many :experiment_videos
    has_many :videos, :through => experiment_videos
    has_many :user_experiments
    has_many :users, :through => user_experiments
    has_many :user_experiment_videos


end
