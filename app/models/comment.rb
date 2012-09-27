class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :picture,	:inverse_of => :comments
  
  paginate_per 50

  field :contenido, :type => String
  field :user_id, :type => String
end
