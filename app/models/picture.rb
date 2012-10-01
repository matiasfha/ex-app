class Picture
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  paginates_per 8

  embeds_many :comments
  accepts_nested_attributes_for :comments
  has_many :votos 
  has_and_belongs_to_many :likers, :class_name => "User", :inverse_of => nil
  belongs_to :user

  field :descripcion, :type => String
  field :titulo, :type => String
  field :num_views, :type => Integer, :default => 0
  field :num_likes, :type => Integer, :default => 0
  has_mongoid_attached_file :imagen,
    :path => ':attachment/:id/:style.:extension',
    :storage => :s3,
    :bucket => 'dandoo-pictures',
    :s3_credentials => {
      :access_key_id =>ENV['S3_KEY_ID'],
      :secret_access_key =>ENV['S3_ACCESS_KEY']
      },
    :styles => {
      :thumb => '32x32>',
      :medium => '250x',
      :original => '1920x1680>'
    }

  # validates_attachment :imagen, :presence => true

  
  attr_accessible :imagen,  :descripcion, :titulo, :num_views  
  

  rails_admin do 
    label 'Imagen'
    label_plural 'Imagenes'

    list do 
      field :titulo
      field :descripcion
      field :created_at
      sort_by :id
      sort_reverse true
    end

    field :descripcion
    field :titulo
    field :imagen
  end

  index "comments.id" => 1

  #Retorna las mas populares respecto al numero de likes
  def self.mas_populares(pagina)
    avg = Picture.avg(:num_likes).round()
    self.where(:num_likes.gt => avg).page(pagina)
    
  end
  #Retorna las mas votadas respecto al rating de votos
  def self.mas_votadas(pagina)
    avg = Voto.avg(:valor).round
    pictures = Array.new
    Voto.where(:valor.gte => avg).page(pagina).each do |v|
      pictures.push Picture.find(v.picture_id)
    end
    pictures
  end
  
  #Retorna las mas vistas
  def self.mas_vistas(pagina)
    avg = self.avg(:num_views).round
    self.where(:num_views.gte => avg).page(pagina)
  end

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
      return suma/total
    else
      return total
    end
  end
end
