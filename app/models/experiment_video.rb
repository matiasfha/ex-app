class ExperimentVideo < ActiveRecord::Base

	belongs_to :experiment
	belongs_to :video

end
