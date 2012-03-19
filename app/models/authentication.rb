class Authentication < ActiveRecord::Base

	belongs_to :user

	def create
		abort('holi')
	end

end
