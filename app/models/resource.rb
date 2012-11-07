
class Resource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip

  paginates_per 8

  embeds_many :comments
  accepts_nested_attributes_for :comments
  has_many :votos, :dependent => :delete
  has_and_belongs_to_many :likers, :class_name => "User", :inverse_of => nil
  belongs_to :user

  #Campos generales Imagenes y Videos

  field :descripcion, :type => String
  field :titulo, :type => String
  field :num_views, :type => Integer, :default => 0
  field :num_likes, :type => Integer, :default => 0
  field :type, :type => String, :default => 'imagen'

  #Campos para imagenes
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
      :medium => '333x',
      :large => '700x',
      :original => '1920x1680>'
    }

    #Campos para videos
    field :thumbnail, :type => String
    field :url, :type => String
    field :html, :type => String
    field :provider, :type => String
    # has_mongoid_attached_file :video,
    # :path => ':attachment/:id/:style.:extension',
    # :storage => :s3,
    # :bucket => 'dandoo-videos',
    # :s3_credentials => {
    #   :access_key_id =>ENV['S3_KEY_ID'],
    #   :secret_access_key =>ENV['S3_ACCESS_KEY']
    #   },
    # :styles => {
    # 	:thumb => '330x',
    # 	:large => '700x'
    # }
    # #TODO Verificar tambien para mp4, ogg, webm
    # validates_attachment_content_type :video, :content_type => ['application/x-shockwave-flash', 'application/x-shockwave-flash', 'application/flv', 'video/x-flv','video/x-ms-wmv','video/mp4']

    attr_accessible :imagen,  :descripcion, :titulo, :num_views  
    attr_accessible :thumbnail, :url, :type,:html

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
	    field :url
	end

	index "comments.id" => 1

	#Retorna las mas populares respecto al numero de likes
	def self.mas_populares(pagina,type=nil)
		if type.nil? || type=="todos"
			avg = self.avg(:num_likes).round()
			self.where(:num_likes.gt => avg).order_by([[:created_at,:desc],[:num_likes,:desc]]).page(pagina)
		else
			avg = self.where(:type => type).avg(:num_likes).round()
			self.where(:num_likes.gt => avg, :type => type).order_by([[:created_at,:desc],[:num_likes,:desc]]).page(pagina)
		end
	end
	 
	#Retorna las mas votadas respecto al rating de votos
	def self.mas_votadas(pagina,type=nil)
		if type.nil? || type=="todos"
	    	avg = Voto.avg(:valor)
	    else
	    	avg = Voto.where(:type => type).avg(:valor)
	    end
	    avg = (avg.nil?)? 0 : avg.round
	    resources = Array.new
	    if type.nil? || type=="todos"
		    Voto.where(:valor.gte => avg).order_by([[:created_at,:desc],[:valor,:desc]]).page(pagina).each do |v|
		      resources.push self.find(v.resource_id)
		    end
		else
			Voto.where(:valor.gte => avg,:type => type).order_by([[:created_at,:desc],[:valor,:desc]]).page(pagina).each do |v|
		      resources.push self.find(v.resource_id)
		    end
		end
	    resources
	end
	  
	#Retorna las mas vistas
	def self.mas_vistas(pagina,type=nil)
		if type.nil? || type=="todos"
	    	avg = self.avg(:num_views).round
	    	self.where(:num_views.gte => avg).order_by([[:created_at,:desc],[:num_views,:desc]]).page(pagina)
	    else
	    	avg = self.where(:type => type).avg(:num_views)
	    	avg  = (avg.nil?) ? 0 : avg.round
	    	self.where(:num_views.gte => avg,:type => type).order_by([[:created_at,:desc],[:num_views,:desc]]).page(pagina)
		end
	end

	#Retorna todos los comentarios existentes
	def self.comentarios
	    all.collect { |p| p.comments }.flatten
	end  

	def self.promedio_votos(id)
	    resource = self.find(id)
	    total = resource.votos.count
	    if total != 0
	      suma = 0
	      resource.votos.each do |v|
	        suma+=v.valor
	      end
	      return suma/total
	    else
	      return total
	    end
	end
end
