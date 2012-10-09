class Authentication
  include Mongoid::Document
  belongs_to :user

  field :uid, type: String
  field :provider, type: String

  attr_accessible :uid, :provider
end
