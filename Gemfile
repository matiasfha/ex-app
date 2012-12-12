source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Gems used only for assets and not required
# in production environments	 by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'yui-compressor'
  gem 'jquery-rails'
  gem 'handlebars_assets'

end

gem 'unicorn'
gem 'foreman'
gem 'version'
gem 'mongoid'
gem 'bson_ext'
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'remotipart',"~> 1.0"
gem 'kaminari'
gem 'xml-simple'
gem 'json'
gem 'ruby-oembed'
gem 'valid_email'
gem "mongoid-paperclip", :require => "mongoid_paperclip", :git => "git://github.com/meskyanichi/mongoid-paperclip.git"
gem "aws-s3",            :require => "aws/s3"
gem "aws-sdk"
gem 'recaptcha',			:require => 'recaptcha/rails'
gem 'rails-i18n'
gem 'bitly'

group :development do
  gem 'rb-fsevent'
  gem 'guard-livereload'
  gem 'faker'
  gem 'terminal-notifier-guard'
  gem 'yajl-ruby'
end

group :test do
	gem 'capybara'
	gem 'database_cleaner'
	gem 'mongoid-rspec'
	gem 'launchy'
	gem 'factory_girl_rails'
	gem 'mongoid-rspec'
end

gem 'rspec-rails',:group =>[:development,:test]

