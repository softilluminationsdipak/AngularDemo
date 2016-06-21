class Room < ActiveRecord::Base
	## Relationships
	has_many :appointments
	belongs_to :account

	## Validations
	validates :name, presence: true

	class << self
	  def build(configuration = {})
	    room 												= Room.new(configuration)
	    room.name 									= "Room #{room.account.rooms.count + 1}" if configuration[:name].nil?
	    room.first_appointment_time = Time.parse("09:00")
	    room.last_appointment_time 	= Time.parse("18:00")
	    room
    end		
	end	

	def first_appointment
		if first_appointment_time.present?
			first_appointment_time.strftime('%H:%M')
		else
			''
		end
	end

	def last_appointment
		if last_appointment_time.present?
			last_appointment_time.strftime('%H:%M')
		else
			''
		end
	end

end
