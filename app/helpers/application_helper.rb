module ApplicationHelper

	def http_referer_uri
	  request.env["HTTP_REFERER"] && URI.parse(request.env["HTTP_REFERER"])
	end

	def refered_from_our_site?
	  if uri = http_referer_uri
	    uri.host == request.host
	  end
	end

	def javascript(*files)
		content_for(:head) { javascript_include_tag(*files)}
	end

	def css(*files)
		content_for(:head) { stylesheet_link_tag(*files)}
	end
end
