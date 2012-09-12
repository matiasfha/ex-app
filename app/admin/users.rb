ActiveAdmin.register User do
	form :partial => "form"

	

	show do 
		panel "Detalles de Usuario" do 
			attributes_table_for user do 
				row :id 
				row :nombre 
				row :apellidos 
				row :rut 
				row :nickname
				row :email 
				row("Pais") do 
					Country.find(user.country_id).nombre
				end
				row("Region") do 
					State.find(user.state_id).nombre unless user.state_id.blank?
				end
				row("Comuna") do 
					Commune.find(user.commune_id).nombre unless user.commune_id.blank?
				end
				row("Ciudad") do 
					City.find(user.city_id).nombre unless user.city_id.blank?
				end
				row("Activo?") {status_tag (user.deleted_at? ? "False" : "True"), (user.deleted_at ? :ok : :error)}
				row("Creado el") { user.created_at? ? l(user.created_at, :format => :long) : '-' }
        		row("Actualizado el") { user.updated_at? ? l(user.updated_at, :format => :long) : '-' }
        		row("Ultimo Ingreso") { user.last_sign_in_at? ? l(user.last_sign_in_at,:format => :long) : '-'}
        		row("Total Ingresos") { user.sign_in_count? ? user.sign_in_count : '0'}
			end
		end
	end

	index :download_links => false, :as => :block do |user|
		div :for => user do 
			h2 link_to("#{user.nombre} #{user.apellidos}",admin_user_path(user))
			div do 
				link_to(image_tag(user.avatar.small.url), admin_user_path(user))
			end
			div do 
				user.email
			end
		end
	end

	
	filter :email 
	filter :nickname
	filter :last_sign_in_at
	filter :last_sign_in_ip
	filter :created_at
	filter :updated_at
end
