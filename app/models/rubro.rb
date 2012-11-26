class Rubro
  include Mongoid::Document

  has_many :users
  field :nombre, :type => String
end
