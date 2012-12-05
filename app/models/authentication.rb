class Authentication
  include Mongoid::Document
  belongs_to :user

  field :uid, type: String
  field :provider, type: String

  attr_accessible :uid, :provider,:user_id

  validates_presence_of :usuario_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
end