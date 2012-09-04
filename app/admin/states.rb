ActiveAdmin.register State do
	menu :priority => 3
	form do |f|
		f.inputs do
			f.input :nombre
			f.input :country_id, :as => :select, :collection =>Country.all.map{|u| [u.nombre,u.id]}
		end
		f.actions
	end

	index do 
		column :nombre
		column :country do |state|
			state.country.nombre
		end
		default_actions
	end


end
