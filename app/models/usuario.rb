class Usuario
	include Mongoid::Document
	include Mongoid::Timestamps
	

	embedded_in :user
	has_many :authentications, :dependent => :delete
	accepts_nested_attributes_for :authentications
	has_many :usuario_interests, :dependent => :delete
	accepts_nested_attributes_for :usuario_interests

	belongs_to  :gender
	belongs_to  :civil_statu
	belongs_to  :state #Region
	belongs_to  :commune
	belongs_to  :city
	belongs_to  :ocupacion

	#Atributos
	field :nombre, :type => String
	field :apellidos, :type => String
	field :rut, :type => String
	field :nickname, :type => String
	field :bio, :type => String
	field :nacimiento, :type => Date
	field :avatar_tmp, :type => String
	field :doos, :type => Numeric, :default => 0

	index({ nickname: 1 }, { unique: true, background: true })
	index({rut:1},{unique:true, background:true})

	attr_accessible :nombre,:nacimiento
	attr_accessible :apellidos, :nickname, :rut,  :bio
	attr_accessible :state_id, :commune_id, :city_id, :gender_id, :civil_statu_id,:ocupacion_id
	attr_accessible :avatar, :avatar_tmp,:rut
	attr_accessible :user_interests_attributes

	validates_presence_of :rut, :nickname,:nombre,:apellidos,:nacimiento
	validates_uniqueness_of :rut
end