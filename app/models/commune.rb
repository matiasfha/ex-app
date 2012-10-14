class Commune
  include Mongoid::Document
  field :nombre, type: String
  
  
  belongs_to :state
  has_many  :cities
  has_many :users

  rails_admin do 
  	label 'Comuna'
    label_plural 'Comunas'

    object_label_method :nombre

    list do 
    	field :nombre
    	field :state 
    	sort_by :id
    	sort_reverse true
    end

    field :nombre
    field :state
    field :cities do
    	hide
    end
    field :users do
    	hide
    end
  end
end
