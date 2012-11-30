class UsuarioInterest
	include Mongoid::Document

	belongs_to :usuario
	belongs_to :interest
end