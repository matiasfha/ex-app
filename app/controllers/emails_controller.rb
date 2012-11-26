require "uri"
require "net/http"

class EmailsController < ApplicationController
  def new
  	@email = Email.new
  end


  #Valida el dominio del email dado
  require 'resolv'
  def validate_email_domain(email)
        domain = email.match(/\@(.+)/)[1]
        Resolv::DNS.open do |dns|
            @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
        end
        @mx.size > 0 ? true : false
  end
  
  def create
    validar = (params[:email][:email] =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/)
    #Validar email
    if !validar.nil?
      if validate_email_domain(params[:email][:email])
        if verify_recaptcha
          @email = Email.where(:email => params[:email][:email]).first
          if @email.nil?
            @email = Email.new params[:email]
            render :json => {:success => @email.save, :mensaje => 'OK'}
          else
            render :json => {:success => 'false',:mensaje => 'existe'}
          end
        else
          render :json => {:success => 'false',:mensaje => 'recaptcha'}
        end
      else
        render :json => {:success => 'false',:mensaje => 'dominio'}
      end
    else
      render :json => {:success => 'false',:mensaje => 'email',:validar => validar}
    end
  end

end
