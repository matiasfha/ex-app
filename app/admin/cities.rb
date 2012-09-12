ActiveAdmin.register City do
	menu :priority => 6,:label => "Ciudades",:parent => 'Datos Generales'
	

	form do |f|
		f.inputs do
			f.input :nombre
			f.input :commune_id, :as => :select, :collection => Commune.all.map{|u| [u.nombre,u.id]}
		end
		f.buttons
	end
end
