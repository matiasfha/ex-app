module ApplicationHelper

	def bootstrap_type(type)
		case type
		when :alert
			"alert-block"
		when :error
			"alert-error"
		when :notice
			"alert-info"
		when :success
			"alert-success"
		else
			type.to_s
		end
	end

	def notify_type(type)
		case type
		when :alert
			"notice"
		when :error
			"error"
		when :notice
			"info"
		when :success
			"success"
		else
			type.to_s
		end
	end

	def javascript(*files)
		content_for(:head) { javascript_include_tag(*files)}
	end

	def css(*files)
		content_for(:head) { stylesheet_link_tag(*files)}
	end
end
