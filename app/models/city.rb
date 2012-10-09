class City
  include Mongoid::Document
  field :nombre, type: String
  
  has_many :users
  belongs_to :commune

  rails_admin do 
  	label 'Ciudad'
    label_plural 'Ciudades'

    object_label_method :nombre

    list do 
    	field :nombre
    	field :commune
    	sort_by :id
    	sort_reverse true
    end

    field :nombre
    field :commune
    
    field :users do
    	hide
    end

  end
end
