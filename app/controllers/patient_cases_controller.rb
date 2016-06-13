class PatientCasesController < BaseController

	before_filter :find_clinic, :find_patient
	before_filter :find_patient_case, only: [:edit, :update, :destroy, :show]

	add_breadcrumb "Home", :user_dashboard_path
	add_breadcrumb "Clinics", :clinics_path

	def index
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb "Patient Cases"
		@patient_cases = @patient.patient_cases.latest
	end

	def new
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)
		@patient_case = @patient.patient_cases.build
		set_diagnoses
	end

	def create
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)		
		@patient_case = @patient.patient_cases.build(patient_case_params)		
		if @patient_case.valid?
			@patient_case.save
			redirect_to clinic_patient_patient_cases_path(@clinic, @patient)
		else
			set_diagnoses
			render action: :new
		end
	end

	def show
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)
		add_breadcrumb 'View'
		set_diagnoses
	end

	def edit
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)
		add_breadcrumb 'Edit'
		set_diagnoses
	end

	def update
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)
		if @patient_case.update_attributes(patient_case_params)
			redirect_to clinic_patient_patient_cases_path(@clinic, @patient)
		else
			set_diagnoses
			render action: :edit
		end
	end

	def destroy
		@patient_case.destroy if @patient_case.present?
		respond_to do |format|
			format.html{redirect_to clinic_patient_patient_cases_path(@clinic, @patient), notice: "Successfully deleted patient from #{@clinic.name}"}
			format.json{ render json: @patient_case}
		end
	end


	private

	def find_clinic
		@clinic = current_account.clinics.find_by(slug: params[:clinic_id])
	end

	def find_patient
		@patient = @clinic.patients.find_by(slug: params[:patient_id])
	end

	def find_patient_case
		@patient_case = @patient.patient_cases.find_by(slug: params[:id])
	end

	def patient_case_params
		params.require(:patient_case).permit(:diagnosis1_id, :diagnosis1_description, :diagnosis2_id, :diagnosis2_description, :diagnosis3_id, :diagnosis3_description, :diagnosis4_id, :diagnosis4_description, :accident_description, :description, :primary_deductible, :primary_paid, :fee_schedule_label_id, :secondary_paid, :secondary_deductible, :provider_id, :p_referrer_id, :onset_at, :attorney_id, :first_treated_at, :hcfa_similar_symptoms_date, :accident_time, :hcfa_is_employment_related, :primary_insurance_carrier_assignment, :primary_insurance_carrier_id, :hcfa_is_non_auto_accident, :hcfa_1a_primary, :primary_guarantor_contact_id, :relationship_to_primary_guarantor, :hcfa_is_auto_accident, :accident_date, :primary_insurance_carrier_policy_uid, :primary_insurance_carrier_group_uid, :secondary_insurance_carrier_id, :secondary_insurance_carrier_assignment, :relationship_to_secondary_guarantor, :secondary_guarantor_contact_id, :hcfa_1a_secondary, :secondary_insurance_carrier_policy_uid, :secondary_insurance_carrier_group_uid, :workmanscomp_return_to_work_date, :workmanscomp_start_disability_date, :workmanscomp_end_disability_date, :accident_state, :accident_city, :workmanscomp_start_partial_disability_date, :workmanscomp_end_partial_disability_date, :disability_status_code, :nys_workmanscomp_is_initial_or_final, :workmanscomp_uid, :subx_level, :treatment_phase, :xray_date, :exacerbation_or_reoccurence, :exacerbation_date, :is_xray_available, :hcfa_medicaid_resubmission, :hcfa_10d, :medicare_abn_waiver_signed, :primary_max_pay_per_visit_cents, :primary_max_pay_per_year_cents, :primary_max_pay_per_life_cents, :primary_max_visits_per_year, :primary_max_visits_per_life, :primary_authorization_through_date, :primary_deductible_cents, :primary_paid_cents, :secondary_deductible_cents, :secondary_paid_cents, :secondary_max_pay_per_visit_cents, :secondary_max_pay_per_year_cents, :secondary_max_pay_per_life_cents, :secondary_max_visits_per_year, :secondary_max_visits_per_life, :secondary_authorization_through_date)
	end

	private

	def set_diagnoses
		map = @patient_case.diagnosis_codes_map
	  @diagnosis_codes = current_account.diagnosis_codes.collect { |d|
  		code = map.has_key?(d.id) ? map[d.id] : d
  		{ :id => code.id, :name => code.name, :code => code.code, :description => code.description, :title => code.title }
  	}
  	@diagnosis_codes_hash = { '' => { code: '&larr;', :description => '' }}
  	@diagnosis_codes.each { |h| @diagnosis_codes_hash[h[:id]] = h }		
	end

end
