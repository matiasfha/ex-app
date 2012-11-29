class Ocupacion
  include Mongoid::Document
  field :nombre, type: String

  has_many :usuarios

  

end
