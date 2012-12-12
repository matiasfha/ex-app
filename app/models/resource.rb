
class Resource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  paginates_per 12

  embeds_many :comments
  
  has_many :votos, :dependent => :delete
  belongs_to :user

  #Campos generales Imagenes y Videos

  field :descripcion, :type => String
  field :titulo, :type => String
  field :num_comments, :type => Integer, :default => 0
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
      :large => '244x',
      :original => '1920>'
    }
    ,
    :convert_options => {
    	:large => "-quality 75 -strip",
    	:original => "-quality 100"
    }

    

    #Campos para videos
    field :thumbnail, :type => String
    field :url, :type => String
    field :html, :type => String
    field :provider, :type => String


    attr_accessible :imagen,  :descripcion, :titulo, :num_views
    attr_accessible :thumbnail, :url, :type,:html,:provider
    
    validates_attachment_presence :imagen
    validates_presence_of  :titulo
    validates_presence_of :url, :allow_blank => 'true', :if => :is_imagen?
    
    index "comments.id" => 1

    def is_video?
    	type == 'video'
    end

    def is_imagen?
    	type == 'imagen'
    end

	#Retorna las mas votadas respecto al rating de votos
	def self.mas_votadas(pagina=nil)
	    avg = Voto.avg(:valor)
	    avg = (avg.nil?)? 0 : avg.round
	    resources = Array.new
	    
	    	
	    Voto.where(:valor.gte => avg).order_by([[:valor,:desc],[:created_at,:desc]]).distinct(:resource_id).each do |v|
	      r = self.find(v)
	      	resources.push(r)
	    end
		
	    resources
	end

	def self.mas_comentados(pagina=nil)
		avg = self.avg(:num_comments).round
		if avg == 0
			avg = 1
		end
		if pagina.nil?
			self.where(:num_comments.gte => avg).order_by([[:num_comments,:desc],[:created_at,:desc]])
		else
			self.where(:num_comments.gte => avg).order_by([[:num_comments,:desc],[:created_at,:desc]]).page(pagina)
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

	def self.nuevos(pagina=nil)
		time = Time.now - 5.days
		if page.nil?
			Resource.where(:created_at.gte => time).order_by([[:created_at,:desc]])
		else
			Resource.where(:created_at.gte => time).order_by([[:created_at,:desc]]).page(pagina)
		end
	end

end
