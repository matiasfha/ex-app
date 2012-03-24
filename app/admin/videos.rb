ActiveAdmin.register Video do
  
  index do
    column "Name", :sortable => :last_name do |video|
      video.name.to_s
    end
    column :character_duration
    column :correct_keyword
    default_actions
  end

  form do |f|
    f.inputs "Video Details" do
      f.input :name
      f.input :content
      f.input :description
      f.input :character_duration
      f.input :correct_keyword
      f.input :keywords
    end
    f.buttons
  end

  show do
    panel "Video Details" do
      attributes_table_for Video.find(params[:id]) do 
        row :id
        row :name
        row("Description") { Video.find(params[:id]).description ? Video.find(params[:id]).description.html_safe : "-" }
        row :character_duration
        row :correct_keyword
        row :keywords
        row("Content") { render 'get_video' }
        row("Created At") { Video.find(params[:id]).created_at? ? l(Video.find(params[:id]).created_at, :format => :long) : '-' }
        row("Updated At") { Video.find(params[:id]).updated_at? ? l(Video.find(params[:id]).updated_at, :format => :long) : '-' }
      end
    end
  end

end
