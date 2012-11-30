class Rubro
  include Mongoid::Document

  field :nombre
  has_many :empresas
end
