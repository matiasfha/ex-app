class UserExperimentVideo < ActiveRecord::Base

	belongs_to :experiment
	belongs_to :video
	belongs_to :user


end
