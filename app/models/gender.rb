class Gender
  include Mongoid::Document
  has_many :usuarios

  field :descripcion, :type => String

  
end
