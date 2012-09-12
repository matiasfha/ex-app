ActiveAdmin.register Picture do
	form :partial => "form"


	index :download_links => false, :as => :block do |picture|
		div :for => picture do 
			div do 
				if picture.imagen_processing.nil?
					link_to(image_tag(picture.imagen.thumb.url), admin_picture_path(picture))
				else
					div do 
						"Procesando"
					end
					
				end
			end
			div do
				"Comentarios: #{picture.comments.count}"
			end
			div do
				"Votos: #{picture.votos.count}"
			end
		end
	end

	show do
		div :style=>"float:left" do
			h3 picture.titulo
			div do 
				if picture.imagen_processing.nil?
					link_to image_tag(picture.imagen.large.url || picture.imagen.url), picture.imagen.url
				else
					div do 
						"Procesando"
					end
					
				end

			end
			div do 
				"Comentarios: #{picture.comments.count}"
			end
			div do 
				"Votos: #{picture.votos.count}"
			end
			div do 
				if picture.user?
					"Tiene Usuario"
				else
					"Subido por Admin"
				end
			end
		end
		div :style => "width:40%;position:relative;float:right;" do 
			picture.comments.each do |comment|
				div :style => "width:10%;position:relative;float:left" do 
					# image_tag(User.find(comment.user_id).avatar.url(:thumb),:style => "width:32px;height:32px")
					"Imagen"
				end
				div :style => "width:80%;position:relative;float:right" do 
					comment.contenido
				end
				div :style => "clear:both;border-bottom:1px black solid;margin-top:5px;margin-bottom:5px"
			end
		end
	end
end
