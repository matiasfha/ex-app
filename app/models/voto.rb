class Voto
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  embedded_in :picture
  embedded_in :user

  field :valor, :type => Integer
end
