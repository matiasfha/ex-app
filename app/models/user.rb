class User < ActiveRecord::Base
  
  belongs_to :sex
  has_many :authentications
  has_many :refs

  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
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
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.image = auth["info"]["image"]
      p = (0...10).map{65.+(rand(25)).chr}.join
      user.password = p
      user.password_confirmation = p
      user.random_pass = p
      user.referal = ref
      user.active = true
    end
    return u.id
  end


end