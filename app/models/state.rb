class State
  include Mongoid::Document
  field :nombre, type: String

  
  belongs_to :country

  has_many :communes
  has_many :users

  attr_accessible :nombre,:country_id

  rails_admin do 
  	label 'Region'
    label_plural 'Regiones'
    object_label_method :nombre

    list do 
    	field :nombre
    	field :country
    	sort_by :id
    	sort_reverse true
    end

    field :nombre
    field :country
    field :communes do
    	hide
    end
    field :users do
    	hide
    end

  end
end
