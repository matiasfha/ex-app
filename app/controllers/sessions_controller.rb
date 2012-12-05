class SessionsController < Devise::SessionsController
	before_filter :require_no_authentication, :only => [:new,:create]
	before_filter :allow_params_authentication!, :only => :create
	layout 'application'
	def new
		self.resource = build_resource(nil, :unsafe => true)
    		clean_up_passwords(resource)
    		respond_with(resource, serialize_options(resource))
	end


	def after_sign_in_path_for(resource)
	    root_path
	 end

	 def after_sign_out_path_for(resource_or_scope)
	  	root_path
	end
end