class Voto
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :resource
  belongs_to :user

  field :valor, :type => Integer
  field :type, :type => String, :default => 'imagen'

  attr_accessible :valor, :user_id, :resource_id

  paginates_per 8
end
