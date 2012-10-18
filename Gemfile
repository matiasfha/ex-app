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
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'yui-compressor'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'less-rails-bootstrap'

end

gem 'unicorn'
gem 'heroku'
gem 'foreman'

gem 'i18n'
#TODO gem 'localeapp'
gem 'formtastic'
gem 'rails_admin'
gem 'mongoid'
gem 'bson_ext'
gem 'devise'
gem 'devise-i18n'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'remotipart',"~> 1.0"
gem 'kaminari'
gem 'ruby-oembed'
gem 'valid_email'

gem "mongoid-paperclip", :require => "mongoid_paperclip", :git => "git://github.com/meskyanichi/mongoid-paperclip.git"
gem "aws-s3",            :require => "aws/s3"
gem "aws-sdk"

gem 'recaptcha',			:require => 'recaptcha/rails'
gem 'googlecharts'


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

