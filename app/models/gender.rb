class Gender
  include Mongoid::Document
  has_many :users

  field :descripcion, :type => String
end
