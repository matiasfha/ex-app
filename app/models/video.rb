class Video < ActiveRecord::Base


  has_many :questions
  has_many :user_videos
  has_many :user_experiment_videos
  has_many :users, :through => :user_experiment_videos
  has_many :experiments, :through => :user_experiment_videos


  has_attached_file :content, :styles => { :medium => "300x300>", :thumb => "64x64>" },   
                    :storage => :s3,
                    :bucket => 'dandoo-videos',
                    :s3_credentials => {
                      :access_key_id => 'AKIAJK5NVAGQBRCX4GQA',
                      :secret_access_key => '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'
                    },
                    :path => ":attachment/:id/:style.:basename.:extension"

  has_attached_file :preview, :styles => { :medium => "300x300>", :thumb => "64x64>" },   
                    :storage => :s3,
                    :bucket => 'dandoo-videos-preview',
                    :s3_credentials => {
                      :access_key_id => 'AKIAJK5NVAGQBRCX4GQA',
                      :secret_access_key => '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'
                    },
                    :path => ":attachment/:id/:style.:basename.:extension"

end
