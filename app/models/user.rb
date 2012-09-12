class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Paperclip
  include Mongoid::Paranoia
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  #Relaciones
  has_many :authentications, :dependent => :delete
  belongs_to  :gender
  belongs_to  :civil_statu
  belongs_to  :country
  belongs_to  :state #Region
  belongs_to  :commune
  belongs_to  :city

  has_many :pictures
  embeds_many :comments
  embeds_many :votos

  #Atributos
  field :nombre, :type => String
  field :apellidos, :type => String
  field :rut, :type => String
  field :nickname, :type => String
  field :bio, :type => String
  field :ocupacion, :type => String
  field :nacimiento, :type => Date
  
  field :avatar_processing, :type => Boolean
  field :avatar_tmp, :type => String  


  index({ email: 1 }, { unique: true, background: true })
  index({ nickname: 1 }, { unique: true, background: true })

  attr_accessible :nombre,:email,:password,:password_confirmation, :remember_me, :created_at, :updated_at
  attr_accessible :apellidos, :nickname, :rut, :avatar,:avatar_cache, :bio, :ocupacion, :nacimiento
  attr_accessible :country_id, :state_id, :commune_id, :city_id, :gender_id, :civil_statu_id


  mount_uploader :avatar, ImagenUploader
  process_in_background :avatar
  store_in_background :avatar
  

  

end
