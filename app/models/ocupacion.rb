class Ocupacion
  include Mongoid::Document
  field :nombre, type: String

  has_many :users

  rails_admin do 
  	label 'Ocupacion'
    label_plural 'Ocupaciones'
	
	object_label_method :nombre

    list do 
    	field :nombre
    	sort_by :id
    	sort_reverse true
    end

    field :nombre

    
  end

end
