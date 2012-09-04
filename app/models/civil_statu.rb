class CivilStatu
  include Mongoid::Document
  field :descripcion, type: String
  has_many :users
end
