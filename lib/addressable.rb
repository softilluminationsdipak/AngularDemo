module Addressable
	def self.included(base)
		base.send :include, InstanceMethods
		base.extend ClassMethods
	end

	module ClassMethods
		def acts_as_addressable
			## Callbacks
			before_save :assign_addressable
			## Relationships
			belongs_to :address, validate: false, dependent: :destroy
			accepts_nested_attributes_for :address
		end
	end

	module InstanceMethods
		def assign_addressable
			address.addressable = contact unless address.nil?
		end
	end
end