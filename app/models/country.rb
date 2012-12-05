class Country
  include Mongoid::Document
  field :nombre, type: String

  
  has_many :users
  has_many :states

  
end
