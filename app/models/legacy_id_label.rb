class LegacyIdLabel < ActiveRecord::Base
	## Relationships
	validates_uniqueness_of :label, case_sensitive: false, message: "^Duplicate Legacy IDs are not allowed."

	## Scopes
	default_scope { order('label ASC') } 
end
