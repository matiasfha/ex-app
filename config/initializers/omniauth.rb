Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook , ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :twitter, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
end