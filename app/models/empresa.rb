class Empresa
	include Mongoid::Document
	include Mongoid::Timestamps
	

	embedded_in :user
	embeds_one :representante
	belongs_to :rubro


	field :nombre_empresa, :type => String
	field :nombre_legal, :type => String
	field :rut_empresa, :type => String
	field :dv_empresa, :type => Numeric
	field :web, :type => String

	attr_accessible :nombre_empresa,:nombre_legal,:rut_empresa
	attr_accessible :web,:rubro_id,:dv_empresa
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
end