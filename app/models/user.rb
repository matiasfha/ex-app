class User
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :nombre, type: String
  field :email, type: String

  attr_protected :provider, :uid, :name, :email

  def self.create_with_omniauth(auth)
  	create! do |user|
  		user.provider = auth['provider']
  		user.uid      = auth['uid']
  		if auth['info']
  			user.nombre = auth['info']['name'] || ""
  			user.email = auth['info']['email'] || ""
  		end
  	end
  end
end
