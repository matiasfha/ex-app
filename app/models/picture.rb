class Picture
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  embeds_many :comments
  embeds_many :votos
  has_and_belongs_to_many :likers, :class_name => "User", :inverse_of => nil
  belongs_to :user

  field :descripcion, :type => String
  field :titulo, :type => String
  field :imagen_processing, :type => Boolean
  field :imagen_tmp, :type => String
  mount_uploader :imagen, ImagenUploader
  process_in_background :imagen
  store_in_background :imagen
  
  attr_accessible :imagen, :imagen_cache, :descripcion
  attr_accessible :imagen_processing, :imagen_tmp, :titulo  
  index "comments.id" => 1

  #Retorna todos los comentarios existentes
  def self.comentarios
    all.collect { |p| p.comments }.flatten
  end  
end
