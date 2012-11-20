class Interest
  include Mongoid::Document

  # has_and_belongs_to_many :user
  # belongs_to :user
  has_many :user_interets
  field :nombre, :type => String
  attr_accessible :nombre


  validates_presence_of :nombre
  validates_uniqueness_of :nombre
end
