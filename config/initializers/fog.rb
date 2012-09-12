
Fog.credentials_path = Rails.root.join('config/s3.yml')
fog_dir = Rails.env == 'production' ? 'dandoo' : 'dandoo.dev'

Mongoid::Document::ClassMethods.send(:include, ::CarrierWave::Backgrounder::ORM::Base)

CarrierWave.configure do |config|
  	config.fog_credentials = {:provider => 'AWS'}
  	config.fog_directory  = fog_dir
	config.root = Rails.root.join('tmp') 
	config.cache_dir = 'cache' 

end



# CarrierWave.configure do |config|
# 	config.fog_credentials = {
# 		:provider 				=> 'AWS',
# 		:aws_access_key_id 		=> 'AKIAJ3CCTJY54TJGQKRQ',
# 		:aws_secret_access_key 	=> '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'
		
#   	},
# 	config.fog_directory = 'dandoo'
# 	config.fog_public = false
# 	config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
# 	config.fog_host = "//dandoo.s3.amazonaws.com"
# 	config.storage = :fog
		
# 	config.root = Rails.root.join('tmp') # adding these...
# 	config.cache_dir = 'carrierwave' # ...two lines
	

# end