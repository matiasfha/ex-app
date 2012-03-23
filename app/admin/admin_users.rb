ActiveAdmin.register AdminUser do
  
  index do
    column "Email", :sortable => :email do |user|
      link_to user.email, admin_admin_user_path(user)
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end

  show do
    panel "User Details" do
      attributes_table_for admin_user do 
        row :id
        row :email
        row :sign_in_count
        row("Current Sign In At") { admin_user.current_sign_in_at? ? l(admin_user.current_sign_in_at, :format => :long) : '-' }
        row("Last Sign In At") { admin_user.last_sign_in_at? ? l(admin_user.last_sign_in_at, :format => :long) : '-' }
        row("Current Sign In IP") { admin_user.last_sign_in_ip? ? admin_user.last_sign_in_ip : '-' }
        row("Last Sign In IP") { admin_user.last_sign_in_ip? ? admin_user.last_sign_in_ip : '-' }
        row("Created At") { admin_user.created_at? ? l(admin_user.created_at, :format => :long) : '-' }
        row("Updated At") { admin_user.updated_at? ? l(admin_user.updated_at, :format => :long) : '-' }
      end
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  filter :created_at
  filter :updated_at

end
