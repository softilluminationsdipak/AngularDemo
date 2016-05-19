class Provider < ActiveRecord::Base

  extend FriendlyId
  friendly_id :signature_name, use: :slugged
  
	include Contactable
  include Addressable

	## Relationships
	belongs_to :clinic

	has_many :providers_legacy_id_labels
	accepts_nested_attributes_for :providers_legacy_id_labels

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

	## Scopes
	scope :alphabetically, -> { includes(:contact).order('contacts.last_name ASC, contacts.first_name ASC')}

	## Methods
  def self.build(configuration={})
    p = self.new(configuration)
    p.build_contact contactable_type: 'Provider'
    p.build_address
    p.preload_existing_legacy_ids
    p.providers_legacy_id_labels.build.build_legacy_id_label
    return p
  end

  def preload_existing_legacy_ids
    LegacyIdLabel.all.each do |legacy_label|
      unless providers_legacy_id_labels.exists?(legacy_id_label_id: legacy_label.id)
        if new_record?
          providers_legacy_id_labels.build legacy_id_label: legacy_label
        else
          providers_legacy_id_labels.create legacy_id_label: legacy_label
        end
      end
    end
  end


end
