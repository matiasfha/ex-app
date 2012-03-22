class User < ActiveRecord::Base
  
  belongs_to :sex
  belongs_to :city
  belongs_to :country
  has_many :auths
  has_many :auths
  has_many :refs
  has_many :occupations
  has_many :user_interests
  has_many :interests, :through => :user_interests

  attr_accessible :name, :image, :email, :password, :password_confirmation, :first_name, :last_name, :rut, :active, :random_pass
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  
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
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.email = auth["info"]["email"]
      user.image = auth["info"]["image"]
      if auth["info"]["location"]!=nil
        loc = auth["info"]["location"].split(', ')
        user.image = loc[1]

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


end