class PatientVisitsController < BaseController
	
	before_action :find_patient_case, :find_patient, :find_clinic
	before_action :find_patient_visit, only: [:show, :edit, :update, :destroy]
	add_breadcrumb "Home", :root_path
	add_breadcrumb "Clinics", :clinics_path

	def index
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)		

		@patient_visits = @patient_case.patient_visits

		## Scenario 1 - Search for todays date - patient visit.
		@patient_visit 	= @patient_visits.select{|p| p.visited_at.to_date == Date.current.to_date}.last
		## Scenario 2 - If not found patient visit then redirect to new patient visit page - that will auto added patient visit.
		unless @patient_visit.present?
			redirect_to new_clinic_patient_patient_case_patient_visit_path(@clinic, @patient, @patient_case)
		end

		## Scenario 3
		if params[:patient_visit_id].present?
			@patient_visit = @patient_case.patient_visits.find_by(id: params[:patient_visit_id])
		end
	end

	def new
		## Auto Build Patient Visit
		@patient_visit = @patient_case.patient_visits.build(visited_at: Time.zone.now)
		@patient_visit.pull_diagnosis_and_dates_from_case(@patient_case.id)
		@patient_visit.save!

		## Auto Build Patient Visit Detail
		@patient_visit_detail = @patient_visit.patient_visit_details.create({
			patient_case_id: @patient_case.id,
			amount_cents: 0,
			place_of_service_code: @clinic.place_of_service,
			units_sold: 1,
			diagnosis_pointer: 'ALL',
			place_of_service_code: 11
		})

		redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id )
	end

	def show
		respond_to do |format|
			format.html{render nothing: true}
			format.js
		end
	end

	def create
	end

	def edit
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)		
		add_breadcrumb 'Patient Visit', clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case)
		add_breadcrumb 'Edit'
	end

	def update
		if @patient_visit.update_attributes(patient_visit_params)
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), notice: 'Successfully updated patient visit information.'
		else
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), flash: {error: @patient_visit.errors.full_messages.join(', ')}
		end
	end

	def destroy
	end

	def diagnosis_chosen
  	if params[:diagnosis_code_id].present?
    	@diagnosis_code = current_account.diagnosis_codes.find(params[:diagnosis_code_id])
    end
    @number = params[:number]
    respond_to do |format|
    	format.html{render nothing: true}
    	format.js{}
    end
  end

	private

	def find_clinic
		@clinic = @patient.clinic
	end

	def find_patient
		@patient = @patient_case.patient
	end

	def find_patient_case
		@patient_case = PatientCase.find_by(slug: params[:patient_case_id])
	end

	def find_patient_visit
		@patient_visit = PatientVisit.find(params[:id])
	end

	def patient_visit_params
		params.require(:patient_visit).permit(:patient_case_id, :visited_at, :fee_slip_number, :onset_at, :first_treated_at, :should_bill_primary, :should_bill_secondary, :should_bill_attorney, :diagnosis1_id, :diagnosis2_id, :diagnosis3_id, :diagnosis4_id, :details, :diagnosis1_description, :diagnosis2_description, :diagnosis3_description, :diagnosis4_description, :primary_patient_bill_id, :secondary_patient_bill_id, :attorney_patient_bill_id)
	end

end
