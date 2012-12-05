class Representante
	  include Mongoid::Document
	  embedded_in :empresa
	  field :nombre, :type => String
	  field :cargo, :type => String
	  field :telefono, :type => String
	  field :tipo_telefono, :type => String
	  field :rut, :type => String
	  field :dv, :type => Numeric
end