class Interest
  include Mongoid::Document

  belongs_to :user

  field :nombre
  attr_accessible :nombre, :user_id

  validates_presence_of :nombre

end
