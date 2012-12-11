class MetadataController < ApplicationController
	#Valida el dominio del email dado
        require 'resolv'
        def validate_email_domain(email)
              domain = email.match(/\@(.+)/)[1]
              Resolv::DNS.open do |dns|
                  @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
              end
              @mx.size > 0 ? true : false
        end

	#Recibe el formulario de Feedback y envia un email
        def feedback
                puts params
                from = params[:email]
                autor = params[:nombre]
                comentario = params[:comentario]
                #Valida que el formato del email sea correcto
                validar = (from =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/)
                if !validar.nil?
                        if validate_email_domain(from)

                                #if verify_recaptcha
                                Emailer.feedback_email(autor,from,comentario).deliver
                                render :json => {:success => true}
                                # else
                                #          render :json => {:success => false, :mensaje => 'recaptcha'}
                                #  end
                        else
                                render :json => {:success => false, :mensaje => 'email'}
                        end
                else
                        render :json => {:success => false, :mensaje => 'email'}
                end
        end
end