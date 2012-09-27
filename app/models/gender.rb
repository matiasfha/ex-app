class Gender
  include Mongoid::Document
  has_many :users

  field :descripcion, :type => String

  rails_admin do 
  	label 'Genero'
    label_plural 'Generos'

    list do 
	  	field :descripcion
	end

  	field :descripcion
	field :users do 
	  	hide
	end
	
  end
end
