class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :resource,	:inverse_of => :comments

  field :contenido, :type => String
  field :user_id, :type => String
end