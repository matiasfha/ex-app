class Authentication < ActiveRecord::Base

	belongs_to :user

	def self.create_with_omniauth(user_id, provider, uid)
	  u = create! do |auth|
        auth.user_id = user_id
        auth.provider = provider
        auth.uid = uid
      end
      return u.id
	end

end
