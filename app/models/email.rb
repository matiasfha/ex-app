class Email
	include Mongoid::Document
  	include Mongoid::Timestamps
  	field :email, :type => String
  	field :ip,    :type => String
end