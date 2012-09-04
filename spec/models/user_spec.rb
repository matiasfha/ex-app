require 'spec_helper'

describe User do
	before(:each) do 
		@user_attr = {
			:nombre => Faker::Name.name,
			:email => Faker::Internet.free_email
		}	

		@auth_attr = {
			:provider => 'twitter',
			:uid 	  => Random.rand(100...999)
		}
	end

	it 'Debe crear un usuario y sus autorizaciones' do
		user = User.new(@user_attr)
		user.save
		user.authentications << Authentication.new(@auth_attr)
		user.authentications << Authentication.new(@auth_attr)
		user.save

		user = User.first
		user.should be_valid
		user.authentications.count.should equal 2
  	end
end
