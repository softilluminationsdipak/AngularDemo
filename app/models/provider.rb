class Provider < ActiveRecord::Base

  extend FriendlyId
  friendly_id :signature_name, use: :slugged
  
	include Contactable
  include Addressable

	## Relationships
	belongs_to :clinic

	acts_as_contactable
  alias :name  :full_name
  alias :title :full_name
  alias :search_title :name

	acts_as_addressable	
	acts_as_paranoid

	## Validations
	validates :signature_name, presence: true, uniqueness: {scope: :clinic_id}
	validates :license, length: { maximum: 10 }, allow_blank: true
	validates :npi_uid, length: { maximum: 10 }, allow_blank: true
	validates :clinic_id, presence: true

end
