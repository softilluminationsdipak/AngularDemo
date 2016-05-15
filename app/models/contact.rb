class Contact < ActiveRecord::Base
  ## Relationships
  belongs_to :contactable, :polymorphic => true

  ## Validations
  validates :email1, :email2, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: 'should be valid email address'}, allow_blank: true

	## Methods
	def full_name
		[first_name, middle_initial, last_name].compact.join(' ')
	end
	alias :name :full_name

	def last_name_first
    [last_name, [first_name, middle_initial].compact.join(" ")].compact.join(', ')
  end  

  def phone_number
  	phone1 || phone2 || phone3
  end
    
end
