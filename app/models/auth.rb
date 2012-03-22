class Auth < ActiveRecord::Base

	belongs_to :user

	def self.create_with_omniauth(user_id, provider, uid)
	  auth = Auth.new
        auth.user_id = user_id
        auth.provider = provider
        auth.uid = uid
      auth.save
      return auth.id
	end

end
