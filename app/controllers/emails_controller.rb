require "uri"
require "net/http"

class EmailsController < ApplicationController
  def new
  	@email = Email.new
  end


  def check_captcha(challenge,response)
    params = {
      :privatekey => ENV['RECAPTCHA_PRIVATE'],
      :remoteip => request.remote_ip,
      :challenge => challenge,
      :response  => response
    }
    x = Net::HTTP.post_form(URI.parse('http://www.google.com/recaptcha/api/verify'), params)
    x.body
  end
  def create
    if check_captcha(params[:recaptcha_challenge_field],params[:recaptcha_response_field])
      @email = Email.where(:email => params[:email][:email]).first
      if @email.nil?
        @email = Email.new params[:email]
        render :json => {:success => @email.save,:mensaje => 'OK'}
      else
        render :json => {:mensaje => 'Ya Existe',:success => 'repeat'}
      end
    else
      render :json => {:success => 'recaptcha'}
    end
  	
  end
end
