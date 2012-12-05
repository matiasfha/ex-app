class State
  include Mongoid::Document
  field :nombre, type: String

  
  belongs_to :country

  has_many :communes
  has_many :usuarios

  attr_accessible :nombre,:country_id

  
end
