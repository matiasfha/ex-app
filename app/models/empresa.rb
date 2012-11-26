class Empresa
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongoid::Paranoia
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
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

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String


  belongs_to :country
  belongs_to :rubro 
  has_many :resources, :dependent => :delete
  has_many :votos,:dependent => :delete
  embeds_many :representantes
  accepts_nested_attributes_for :representantes

  #Atributos
  field :nombre, :type => String
  field :nombre_legal, :type => String
  field :rut, :type => String
  field :dv, :type => Integer
  field :descripcion, :type => String
  field :web, :type => String

  index({ email: 1 }, { unique: true, background: true })
  index({rut:1},{unique:true, background:true})

  attr_accessible :nombre,:email,:password,:password_confirmation, :remember_me, :created_at, :updated_at
  attr_accessible :nombre_legal, :rut, :descripcion
  attr_accessible :country_id, :rubro_id, :avatar
  attr_accessible :representantes_attributes

  validates_presence_of :email, :rut,:nombre,:nombre_legal,:descripcion
  validates_uniqueness_of :email, :rut, :nombre,:nombre_legal

  has_mongoid_attached_file :avatar,
    :path => ':attachment/:id/:style.:extension',
    :storage => :s3,
    :bucket => 'dandoo-avatars',
    :s3_credentials => {
      :access_key_id =>ENV['S3_KEY_ID'],
      :secret_access_key =>ENV['S3_ACCESS_KEY']
      },
    :styles => {
      :thumb => '40x40#',
      :medium => '200x200#',
      :original => '1920x1680>'
    }

  
  def avatar_remote_url(url_value)
    # self.avatar = URI.parse(url_value)
    self.avatar = open(url_value)
  end
  
  
  def self.resource_votados(user_id,pagina)
    resources = Array.new
    Voto.where(:user_id => user_id).page(pagina).each do |voto|
      p = Resource.find(voto.resource_id)
      if !p.nil?
        resources.push p
      end
    end
    resources
  end

end
