class Video < ActiveRecord::Base


  has_many :questions
  has_many :user_videos
  has_many :user_experiment_videos
  has_many :users, :through => :user_experiment_videos

  has_attached_file :content,        
                    :storage => :s3,
                    :bucket => 'alzheimer-videos',
                    :s3_credentials => {
                      :access_key_id => 'AKIAJK5NVAGQBRCX4GQA',
                      :secret_access_key => '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'
                    },
                    :path => ":attachment/:id/:basename.:extension"

end
