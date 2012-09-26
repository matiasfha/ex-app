FactoryGirl.define do 
	factory :user do
		nombre Faker::Name.name
		email  Faker::Internet.free_email
		password '123456'
		password_confirmation '123456'
	end

	factory :authentication do 
		provider 'twitter'
		uid Random.rand(100...999)
	end
end