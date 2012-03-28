class User < ActiveRecord::Base
  
  belongs_to :sex
  belongs_to :city
  belongs_to :country
  belongs_to :commune
  belongs_to :marital_status
  has_many :auths
  has_many :refs
  has_many :user_interests
  has_many :interests, :through => :user_interests
  has_many :user_videos
  has_many :user_experiments
  has_many :experiments, :through => :user_experiments
  has_many :user_experiment_videos
  has_many :videos, :through => :user_experiment_videos

  attr_accessible :name, :image, :email, :password, :password_confirmation, :first_name, :last_name, :rut, :active, :random_pass, :birthdate, :sex_id, :avatar, :avatar_file_name, :marital_status_id, :country_id, :city_id, :address, :occupation, :commune_id, :terms, :description
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create

  has_attached_file :avatar,        
                    :storage => :s3,
                    :bucket => 'alzheimer',
                    :s3_credentials => {
                      :access_key_id => 'AKIAJK5NVAGQBRCX4GQA',
                      :secret_access_key => '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'
                    },
                    :path => ":attachment/:id/:basename.:extension"
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.create_with_omniauth(auth, ref)
    u = create! do |user|
      if auth["info"]["first_name"]!=nil
        user.first_name = auth["info"]["first_name"]
        user.last_name = auth["info"]["last_name"]
      elsif auth["info"]["name"]!=nil
        nom = auth["info"]["name"].split(' ')
        if nom[0]!=nil
          user.first_name = nom[0]
        end
        if nom[1]!=nil
          user.last_name = nom[1]
        end
      end
      user.email = auth["info"]["email"]
      user.image = auth["info"]["image"]
      if auth["info"]["location"]!=nil
        loc = auth["info"]["location"].split(', ')
        city = City.find_by_name(loc[0])
        if city
          user.city = city
        end
        country = Country.find_by_name(loc[1])
        if city
          user.country = country
        end
      end
      if auth['extra']!=nil&&auth['extra']['raw_info']!=nil&&auth['extra']['raw_info']['gender']!=nil
        if auth['extra']['raw_info']['gender']=='male'
          user.sex_id = 2
        elsif auth['extra']['raw_info']['gender']=='female'
          user.sex_id = 1
        end
      end
      p = (0...10).map{65.+(rand(25)).chr}.join
      user.password = p
      user.password_confirmation = p
      user.random_pass = p
      user.referal = ref
      user.active = true
    end
    return u.id
  end

  

  def generate_ref
    begin
        key = (0...5).map{97.+(rand(25)).chr}.join
        key = key.gsub("/","").gsub(".","")
    end while Ref.exists?(:value => key)||key.length!=5
    return key
  end


  def acomplishments
    total = 0
    self.user_experiment_videos.each do |x|
      total += x.succeded
    end
    return total
  end

  def videos_available
    return self.user_experiment_videos.where(:succeded => 0).count
  end

  def where_do_i_fit_in?
    all_active_ex = Experiment.where('start_date < ? AND end_date > ?', Time.now, Time.now)
    #vemos en que experimentos encaja el usuario
    UserExperiment.delete(self.user_experiments)
    all_active_ex.each do |x|
      fits = x.do_i_fit_in? self
      if fits
        self.user_experiments.create(:experiment_id => x.id)
      end
    end

    #asignamos los videos que debería comenzar a ver ahora
    self.experiments.where('start_date < ? AND end_date > ?', Time.now, Time.now).each do |x|
      x.experiment_videos.each do |v|
        if v.play_date.to_s==Time.now.to_date.to_s
          exists = UserExperimentVideo.find_by_user_id_and_video_id_and_experiment_id(self.id, v.id, x.id)
          if !exists
            UserExperimentVideo.create(:experiment_id => x.id, :user_id => self.id, :video_id => v.id)
          end
        end
      end
    end
  end



end

