require 'valid_email'
class Email
	include Mongoid::Document
  	include Mongoid::Timestamps
  	
  	field :email, :type => String
  	field :ip,    :type => String
  	
  	validates :email, :presence => true, :email => {:mx => true,:message =>'El email ingresado no parece ser valido'}
  	validates_presence_of :email	 
  	validates_uniqueness_of :email, :message => 'El email ya esta registrado'

  	
  	before_save { |user| user.email = email.downcase }
end