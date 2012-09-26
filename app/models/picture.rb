class Picture
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  embeds_many :comments
  has_many :votos 
  has_and_belongs_to_many :likers, :class_name => "User", :inverse_of => nil
  belongs_to :user

  field :descripcion, :type => String
  field :titulo, :type => String
  has_mongoid_attached_file :imagen,
    :path => ':attachment/:id/:style.:extension',
    :storage => :s3,
    :bucket => 'dandoo-pictures',
    :s3_credentials => {
      :access_key_id =>'AKIAJ3CCTJY54TJGQKRQ',
      :secret_access_key =>'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'
      },
    :styles => {
      :thumb => '32x32>',
      :medium => '500x500>',
      :original => '1920x1680>'
    }

  # validates_attachment :imagen, :presence => true

  
  attr_accessible :imagen,  :descripcion, :titulo  
  

  index "comments.id" => 1

  #Retorna todos los comentarios existentes
  def self.comentarios
    all.collect { |p| p.comments }.flatten
  end  

  def self.promedio_votos(id)
    picture = Picture.find(id)
    total = picture.votos.count
    if total != 0
      suma = 0
      picture.votos.each do |v|
        suma+=v.valor
      end
      return suma
    else
      return total
    end
  end
end
