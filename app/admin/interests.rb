ActiveAdmin.register Interest do
  
	index do

    column "Name", :sortable => :last_name do |interest|
      link_to interest.name.html_safe, admin_interest_path(interest)
    end
    default_actions
  end


end
