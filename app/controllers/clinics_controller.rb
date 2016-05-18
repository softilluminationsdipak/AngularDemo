class ClinicsController < BaseController

	before_filter :find_clinic, only: [:edit, :update, :destroy, :show]

	def index
		@clinics = current_account.clinics.alphabetically
	end

	def new
    @clinic = current_account.clinics.build
    @clinic.build_clinic_preference
    @clinic.build_contact
    @clinic.build_address
    @clinic.build_billing_address 
	end

	def create
		@clinic = current_account.clinics.build(clinic_params)
		if @clinic.save
			redirect_to clinics_path, notice: 'Successfully created clinic.'
		else
			render :new
		end
	end

	def edit		
    @clinic.build_contact unless @clinic.contact.present?
    @clinic.build_address unless @clinic.address.present?
    @clinic.build_billing_address  unless @clinic.billing_address.present?
    @clinic.build_clinic_preference unless @clinic.clinic_preference.present?
	end

	def update
		if @clinic.update_attributes(clinic_params)
			redirect_to clinics_path, notice: 'Successfully updated clinic.'
		else
			render :edit
		end
	end

	def destroy
		@clinic.destroy if @clinic.present?
		respond_to do |format|
			format.html{redirect_to clinics_path, notice: 'Successfully deleted clinic.'}
			format.json{ render json: @clinic}
		end
		
	end
	
	private

	def clinic_params
		params.require(:clinic).permit(:main_provider_id, :same_as_service_location, :tax_uuid, :type_ii_npi_uuid, :id, contact_attributes: [:company_name, :phone1, :phone1_ext, :fax1, :email1, :phone2, :phone2_ext, :id], address_attributes: [:id, :street, :street2, :city, :state, :zipcode], billing_address_attributes: [:street, :street2, :city, :state, :zipcode, :id], clinic_preference_attributes: [:patient_number_scheme, :should_send_statements_when_overdue, :should_charge_overdue_account, :overdue_fee_percentage, :should_show_clinic_on_letter, :should_show_clinic_on_bill, :letter_use, :statement_use, :should_print_clinic_address_on_envelope, :default_place_of_service, :patient_current_statement_message, :patient_30days_statement_message, :patient_60days_statement_message, :patient_90days_statement_message, :patient_120days_statement_message, :should_print_diagnosis_description_on_hcfa, :workmanscomp_boilerplate, :hcfa_top_margin, :hcfa_left_margin, :id, :box_32_use, :box_33_use, :insurance_carrier_assignment_policy => [] ])
	end

	def find_clinic
		@clinic = current_account.clinics.find_by(slug: params[:id])
	end

end
