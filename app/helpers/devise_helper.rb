module DeviseHelper
	def devise_error_messages!
		return nil if resource.errors.empty?
		return resource.errors.to_a
	end
end