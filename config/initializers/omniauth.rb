Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter , ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope =>'email,user_birthday',:image_size =>'large'
end