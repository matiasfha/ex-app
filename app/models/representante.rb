class Representante
  include Mongoid::Document

  embedded_in :empresa

  field :nombre		, :type => String
  field :rut		, :type => String
  field :dv			, :type => Integer
  field :cargo		, :type => String
  field :telefono	, :type => String

end
