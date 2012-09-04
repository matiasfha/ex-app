class City
  include Mongoid::Document
  field :nombre, type: String
  
  has_many :users
  belongs_to :commune
end
