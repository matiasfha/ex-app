class Country
  include Mongoid::Document
  field :nombre, type: String

  
  has_many :users
  has_many :states

  rails_admin do 
  	label 'Pais'
    label_plural 'Paises'
	
	object_label_method :nombre

    list do 
    	field :nombre
    	sort_by :id
    	sort_reverse true
    end

    field :nombre

    field :states do 
    	hide
    end
  end
end
