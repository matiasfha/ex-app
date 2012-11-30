class ResourcesController < ApplicationController
	layout :get_layout
	before_filter :authenticate_user!, :only => [:create,:destroy]
	respond_to :html


	def show
		@resource = Resource.find(params[:id])
		# @resource.num_views+=1;
		# @resource.save
		@comments = @resource.comments.limit(10)

		# respond_with(@resource) do |format|
  # 			format.html
  # 			format.json {render :partial => 'resources/item',:formats => [:json]}
		# end
	end

	def mas_votados
		@resources = Resource.mas_votadas(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def nuevos
		@resources = Resource.all.order_by([[:created_at,:desc]]).page(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	def mas_comentados
		@resources =  Resource.mas_comentados(params[:page])
		respond_with(@resource) do |format|
  			format.html {render :partial => 'resources/listado'}
		end
	end

	protected
	def get_layout
		request.xhr? ? nil : 'application'
	end

	
end