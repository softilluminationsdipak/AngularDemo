class ProvidersLegacyIdLabel < ActiveRecord::Base
	## Relationships
	belongs_to :provider
	belongs_to :legacy_id_label, autosave: true, validate: true

	accepts_nested_attributes_for :legacy_id_label, reject_if: proc { |attributes| attributes['label'].blank? }

	## Scopes
	default_scope { includes(:legacy_id_label).order('legacy_id_labels.label ASC') }
end
