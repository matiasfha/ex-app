require 'open-uri'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Paranoia
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  #validates_presence_of :email
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
  has_many :resources,:dependent => :delete
  has_many :votos,:dependent => :delete
  
  #Para el caso de ser un usuario
  has_many :authentications, :dependent => :delete
  accepts_nested_attributes_for :authentications
  ######################################
  belongs_to  :country

  field :tipo_usuario, :type => String, :default => 'usuario'
  field :language, :type => String, :default => 'es'
  embeds_one :usuario
  embeds_one :empresa
  #accepts_nested_attributes_for :empresa,:usuario

  index({ email: 1 }, { unique: true, background: true })



  attr_accessible :email,:password,:password_confirmation
  attr_accessible :country, :remember_me, :created_at, :updated_at
  attr_accessible :tipo_usuario, :avatar,:avatar_tmp
  #attr_accessible :usuario_attributes, :empresa_attributes

  validates_presence_of :email
  validates_uniqueness_of :email

  has_mongoid_attached_file :avatar,
    :path => ':attachment/:id/:style.:extension',
    :storage => :s3,
    :bucket => 'dandoo-avatars',
    :s3_protocol => "http",
    :s3_credentials => {
      :access_key_id =>ENV['S3_KEY_ID'],
      :secret_access_key =>ENV['S3_ACCESS_KEY']
      },
    :styles => {
      :thumb => '27x24#',
      :original => '1920x1680>'
    }


  def avatar_remote_url(url_value)
    #self.avatar = URI.parse(url_value)
    self.avatar = open(url_value)
  end


  # def self.resource_votados(user_id,pagina)
  #   resources = Array.new
  #   Voto.where(:user_id => user_id).page(pagina).each do |voto|
  #     p = Resource.find(voto.resource_id)
  #     if !p.nil?
  #       resources.push p
  #     end
  #   end
  #   resources
  # end


end