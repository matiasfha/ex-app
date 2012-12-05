class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :resource,	:inverse_of => :comments

  field :contenido, :type => String
  field :user_id, :type => String

  attr_accessible :user_id, :contenido
end