class Voto
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :picture
  belongs_to :user

  field :valor, :type => Integer

  attr_accessible :valor, :user_id, :picture_id

  
end
