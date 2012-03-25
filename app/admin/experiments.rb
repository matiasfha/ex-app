ActiveAdmin.register Experiment do
  
  index do

    column "Name", :sortable => :last_name do |experiment|
      link_to experiment.name.html_safe, admin_experiment_path(experiment)
    end
    column :start_date
    column :end_date
    default_actions
  end

  form :partial => 'form'

  show do
    panel "Experiment Details" do
      attributes_table_for experiment do 
        row :id
        row :name
        row("Description") { experiment.description ? experiment.description.html_safe : "-" }
        row :start_date
        row :end_date
        row("Stadistics") {  }
        row("Created At") { experiment.created_at? ? l(experiment.created_at, :format => :long) : '-' }
        row("Updated At") { experiment.updated_at? ? l(experiment.updated_at, :format => :long) : '-' }
      end
    end
    active_admin_comments
  end


end
