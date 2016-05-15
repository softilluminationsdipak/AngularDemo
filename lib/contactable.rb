module Contactable
	def self.included(base)
		base.send :include, InstanceMethods
		base.extend ClassMethods
	end

	module ClassMethods
		def acts_as_contactable
			## Callbacks
			after_save :assign_contactable

			## Reationships
			belongs_to :contact, dependent: :destroy
			accepts_nested_attributes_for :contact
		end
	end

	module InstanceMethods
		delegate :last_name_first, to: :contact
		delegate :full_name, to: :contact

    def contact_first_name_blank
      if contact && contact.first_name.blank?
        errors.add(:base, 'Contact first name can not be blank') 
        contact.errors.add('first_name', 'can not be blank')
      end
    end
  
    def contact_last_name_blank
      if contact && contact.last_name.blank?
        errors.add(:base, 'Contact last name can not be blank') 
        contact.errors.add('last_name', 'can not be blank')
      end
    end

    def contact_sex_blank
      if contact && contact.sex != 'male' && contact.sex != 'female'
        errors.add(:base, "Contact sex should be one of 'male' or 'female' and can not be blank")
        contact.errors.add 'sex', 'cannot be blank'
      end
    end
    
    def contact_company_name_blank
      if contact && contact.company_name.blank?
        errors.add(:base, 'Contact company name can not be blank')
        contact.errors.add('company_name', 'must be present')
      end
    end
    
    def contact_attention_blank
      if contact && contact.attention.blank?
        errors.add(:base, 'Contact attention can not be blank')
        contact.errors.add('attention', 'must be present')
      end
    end
		
		def assign_contactable
			unless contact.nil?
				contact.contactable = self
				contact.save
			end
		end
	end
end