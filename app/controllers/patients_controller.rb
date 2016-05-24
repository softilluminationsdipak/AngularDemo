class PatientsController < BaseController
	
	before_filter :find_clinic
	before_filter :find_patient, only: [:edit, :update, :destroy, :show, :toggle_active_status]

	add_breadcrumb "Home", :root_path
	add_breadcrumb "Clinics", :clinics_path	

	def index
		return redirect_to new_clinic_path, flash: {error: 'Kindly create clinic to manage patients.'} if current_account.clinics.count == 0
		return redirect_to clinic_patients_path(current_account.try(:clinics).try(:latest).try(:first)) unless @clinic.present?				
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		if @clinic.present?
			@patients = @clinic.patients			
		else
			@clinic 	= current_account.clinics.latest.first
			@patients = @clinic.patients			
		end
	end

	def new
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'New Patient'
		
		@patient = @clinic.patients.build

    @patient.build_contact contactable_type: 'Patient' if @patient.contact.nil?
    @patient.build_address if @patient.address.nil?
    @patient.build_employer_contact unless @patient.employer_contact.present?
    @patient.build_employer_address unless @patient.employer_address.present?
	end

	def create
		@patient = @clinic.patients.build(patient_params)
		if @patient.save
			redirect_to clinic_patients_path(@clinic), notice: "Successfully created patient for #{@clinic.name}"
		else
			render action: :new
		end
	end

	def edit
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb "#{@patient.full_name}"
	end

	def update
		if @patient.update_attributes(patient_params)
			redirect_to clinic_patients_path(@clinic), notice: "Successfully updated patient infomation for #{@clinic.name}"
		else
			render action: :edit
		end
	end

	def destroy
		@patient.destroy if @patient.present?
		respond_to do |format|
			format.html{redirect_to clinic_patients_path(@clinic), notice: "Successfully deleted patient from #{@clinic.name}"}
			format.json{ render json: @patient}
		end
	end


  def toggle_active_status
  	@patient.update_attributes(is_active: !@patient.is_active)
  	redirect_to edit_clinic_patient_path(@clinic, @patient), notice: "#{@patient.full_name.titleize} is now an #{@patient.active_text} patient.".html_safe
  end

  def add_family_member_for
  	ancestor = @clinic.patients.find_by(slug: params[:id])
  	if ancestor.present?
  		@patient = @clinic.patients.build.copy_details_from_patient(ancestor)
  		@patient.save
  		redirect_to edit_clinic_patient_path(@clinic, @patient)    
  	else
  		redirect_to clinic_patients_path(@clinic)
  	end
  end

	private

	def find_patient
		@patient = @clinic.patients.find_by(slug: params[:id])
	end

	def patient_params
		params.require(:patient).permit(:account_code, :spouse_name, :is_active, :address_stationery_to_label, :statement_message, :overdue_fee_percentage, :should_send_statements_when_overdue, :is_full_time_student, :disability_status_code, :employment_status_code, :category, :marital_status_code, :p_referrer_id, :clinic_id, :ssn, :birthdate, contact_attributes: [:id, :last_name, :first_name, :middle_initial, :sex, :phone3, :phone1, :phone2, :phone2_ext, :email1, :title, :notes, :occupation, :company_name, :attention, :phone1_ext, :phone3_ext, :fax1, :email2, :notes], address_attributes: [:id, :street, :street2, :city, :state, :zipcode], employer_address_attributes: [:id, :street, :street2, :city, :state, :zipcode], employer_contact_attributes: [:id, :company_name, :occupation])
	end

	def find_clinic
		@clinic = current_account.clinics.find_by(slug: params[:clinic_id])
	end

end
