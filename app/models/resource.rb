
class Resource
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  paginates_per 8

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


    attr_accessible :imagen,  :descripcion, :titulo, :num_views
    attr_accessible :thumbnail, :url, :type,:html,:provider

    index "comments.id" => 1

	

	#Retorna las mas votadas respecto al rating de votos
	def self.mas_votadas(pagina=nil)
	    avg = Voto.avg(:valor)
	    avg = (avg.nil?)? 0 : avg.round
	    resources = Array.new
	    
	    	if pagina.nil?
	    		Voto.where(:valor.gte => avg).order_by([[:created_at,:desc],[:valor,:desc]]).each do |v|
		      		resources.push self.find(v.resource_id)
		    	end
	    	else
		    Voto.where(:valor.gte => avg).order_by([[:created_at,:desc],[:valor,:desc]]).page(pagina).each do |v|
		      resources.push self.find(v.resource_id)
		    end
		end
	    resources
	end

	def self.mas_comentados(pagina=nil)
		avg = self.avg(:num_comments).round
		if pagina.nil?
			self.where(:num_comments.gte => avg).order_by([[:created_at,:desc],[:num_comments,:desc]])
		else
			self.where(:num_comments.gte => avg).order_by([[:created_at,:desc],[:num_comments,:desc]]).page(pagina)
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
