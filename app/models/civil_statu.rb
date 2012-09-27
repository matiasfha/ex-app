class CivilStatu
  include Mongoid::Document
  field :descripcion, type: String
  has_many :users

  rails_admin do 
  	label 'Estado Civil'
    label_plural 'Estados Civiles'
    
    list do 
	  	field :descripcion
	end

  	field :descripcion
	field :users do 
	  	hide
	end

  end


end
