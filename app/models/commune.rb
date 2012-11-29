class Commune
  include Mongoid::Document
  field :nombre, type: String
  
  
  belongs_to :state
  has_many  :cities
  has_many :usuarios

  
end
