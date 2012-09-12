ActiveAdmin.register Commune do
  menu :priority => 5, :label => "Comunas",:parent => 'Datos Generales'		

  form do |f|
		f.inputs do
			f.input :nombre
			f.input :state_id, :as => :select, :collection => State.all.map{|u| [u.nombre,u.id]}
		end
		f.buttons
	end
end
