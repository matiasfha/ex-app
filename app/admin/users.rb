ActiveAdmin.register User do
  
  index do
    column "Email", :sortable => :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column "Name", :sortable => :last_name do |user|
      user.first_name.to_s+' '+user.last_name.to_s
    end
    column :rut
    column :birthdate
    column :occupation
    column "Image" do |user|
      image_tag (user.avatar.url!='/avatars/original/missing.png' ? user.avatar.url : user.image!='' ? user.image : 'missing.png' ), :style => 'max-height: 50px'
    end
    column "Provider" do |user|
      user.auths.first ? (user.auths.first.provider=='twitter' ? (image_tag 'twitter_64.png', :style => 'height: 32px') : (image_tag 'facebook_64.png', :style => 'height: 32px')) : '-'
    end
    # column "Admin" do |user|
    #   status_tag (user.admin ? "True" : "False"), (user.admin ? :ok : :error)
    # end
    column "Active" do |user|
      status_tag (user.active ? "True" : "False"), (user.active ? :ok : :error)
    end
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :rut
      f.input :birthdate
      f.input :occupation
      f.input :sex
      f.input :country
      f.input :city
      f.input :commune
      f.input :terms
      f.input :description
    end
    f.buttons
  end

  show do
    panel "User Details" do
      attributes_table_for user do 
        row :id
        row :email
        row :first_name
        row :last_name
        row :rut
        row :birthdate
        row :occupation
        row("Sex") { user.sex ? user.sex.name : "-"  }
        row("Marital Status") { user.marital_status ? user.marital_status.name : "-"  }
        row("Country") { user.country ? user.country.name : "-"  }
        row("City") { user.city ? user.city.name : "-"  }
        row("Commune") { user.commune ? user.commune.name : "-"  }
        #row("Is Admin?") { status_tag (user.admin? ? "True" : "False"), (user.admin ? :ok : :error)  }
        row("Is Active?") { status_tag (user.active? ? "True" : "False"), (user.active ? :ok : :error)  }
        row("Created At") { user.created_at? ? l(user.created_at, :format => :long) : '-' }
        row("Updated At") { user.updated_at? ? l(user.updated_at, :format => :long) : '-' }
      end
    end
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :rut
  filter :birthdate
  filter :occupation
  filter :sex_id
  filter :country_id
  filter :city_id
  filter :commune_id
  filter :created_at
  filter :updated_at
end
