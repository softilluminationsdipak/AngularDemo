class AppointmentsController < BaseController

	before_action :find_clinic, :find_patient
	before_action :contacts_scoper, :assign_patient, :assign_contact
	before_action :find_appointment, only: [:destroy, :show, :update, :edit]

  WORKING_HOURS_BEGIN 		= "08:00"
  WORKING_HOURS_END 			= "18:59"
  DAY_INTERVAL_IN_MINUTES = 15
  SPECIAL_TYPES 					= []

	def index
		if params[:contact_id].present?
			contact = contacts_scoper.find(params[:contact_id])
		elsif @patient.present?
			contact = @patient.contact			
		else
			contact = contacts_scoper.first
		end
		redirect_to day_at_glance_clinic_patient_appointments_path(@clinic, @patient, contact_id: contact.id, date: params[:date])
	end

	def day_at_glance
		if params[:date]
			@date = Date.parse(params[:date])
		else
			@date = Date.current
		end
		day_at_glance_grid(@date)
	end

	def week_at_glance
	end

	def new
	end

	def create
		@appointment = @clinic.appointments.build(appointment_params)		
		@appointment.start_time 		= @appointment.starts_at
		@appointment.recurring_type = 'one_time'
		if @appointment.save
			redirect_to day_at_glance_clinic_patient_appointments_path(@clinic, @patient, contact_id: @appointment.contact_id), notice: 'Successfully added appointment.'
		else
			redirect_to day_at_glance_clinic_patient_appointments_path(@clinic, @patient, contact_id: @appointment.contact_id), flash: {error: @appointment.errors.full_messages.first }
		end
	end

	def show
	end

	def edit
	end

	def update
	end

	def destroy
		@appointment.destroy if @appointment.present?
		respond_to do |format|
			format.html{redirect_to day_at_glance_clinic_patient_appointments_path(@clinic, @patient, contact_id: @appointment.contact_id)}
			format.json{ render json: @appointment}
		end
	end

	private

	def find_clinic
		@clinic = current_account.clinics.find_by(slug: params[:clinic_id])
	end

	def find_patient
		@patient = current_account.patients.find_by(slug: params[:patient_id])
	end

	def contacts_scoper
		Contact.joins("INNER JOIN patients ON patients.id = contacts.contactable_id INNER JOIN clinics ON patients.clinic_id = clinics.id").where("contacts.contactable_type = ? AND clinics.account_id = ?", "Patient", current_account.id).group("contacts.id")
	end

	def find_appointment
		@appointment = @clinic.appointments.find(params[:id])
	end

	def appointment_params
		params.require(:appointment).permit(:clinic_id, :patient_id, :date, :contact_id, :room_id, :starts_at, :ends_at, :provider_id, :notes, :duration_units, :recurring_type, :recurring_day, :start_time)
	end

  def assign_patient
    if params[:contact_id] && params[:contact_id] != 'undefined'
      @contact = contacts_scoper.find(params[:contact_id])
      @patient = @contact.contactable if Patient === @contact.contactable
    end
  end

  def assign_contact
    unless params[:contact_id].nil?
      @contact = contacts_scoper.where("contacts.id = ?", params[:contact_id])    	
    end
  end

	def day_at_glance_grid(day)
		@appointments 			= Appointment.for_date(day).joins(:contact).where("contacts.id IN (?)", contacts_scoper.map(&:id))
		(@columns 					= current_account.rooms << SPECIAL_TYPES).flatten
    @grid 							= []
    @longest_intervals 	= []

    @columns.each_with_index do |column, column_number|
    	@grid[column_number] = {}
      if Room === column
        intervals = get_intervals_for(day, column.first_appointment_time.to_s, column.last_appointment_time.to_s)
      else
        intervals = get_intervals_for(day, WORKING_HOURS_BEGIN, WORKING_HOURS_END)
      end      
      @longest_intervals = intervals if intervals.size > @longest_intervals.size      
      intervals.each_with_index do |interval, index|
        if Room === column
          @grid[column_number][interval.strftime('%H:%M')] = @appointments.detect { |a|           	
            (a.room_id == column.id && a.starts_at.strftime('%x %H:%M') == interval.strftime('%x %H:%M')) 
          }          
        end
      end
    end        

    @totals = @grid.collect{ |column| column.map { |row| row[1] }.compact.length }   
    @appointment = @clinic.appointments.build    
	end

	def get_intervals_for(day, appt_start, appt_end)
    intervals = []
    interval 	= day_begin = Time.parse(day.to_s + ' ' + appt_start)
    day_end 	= Time.parse(day.to_s + ' ' + appt_end)
    while interval < day_end
      intervals << interval
      interval += DAY_INTERVAL_IN_MINUTES * 60
    end
    intervals		
	end

end