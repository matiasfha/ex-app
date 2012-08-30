ActiveAdmin.register Interest do
  
  index do

    column "Name", :sortable => :name do |interest|
      link_to interest.name.html_safe, admin_interest_path(interest)
    end
    column "Users that like this" do |interest|
      interest.users.count.to_s
    end
    default_actions
  end


end
