class UserInterest
	include Mongoid::Document

	belongs_to :user 
	belongs_to :interest 
end