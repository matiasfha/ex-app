class City
  include Mongoid::Document
  field :nombre, type: String
  
  has_many :usuarios
  belongs_to :commune

  
end
