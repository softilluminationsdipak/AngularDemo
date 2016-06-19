class PatientVisitDetailsController < BaseController

	before_action :find_patient_case, :find_patient, :find_clinic, :find_patient_visit
	before_action :find_patient_visit_detail, only: [:show, :edit, :update, :destroy]

	def index
	end

	def new
	end

	def create
		@patient_visit_detail = @patient_visit.patient_visit_details.build(patient_visit_detail_params)
		if @patient_visit_detail.save
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), notice: 'Successfully added patient visit detail information.'
		else
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), flash: {error: @patient_visit_detail.errors.full_messages.try(:first)}
		end
	end

	def edit
	end

	def update
		if @patient_visit_detail.update_attributes(patient_visit_detail_params)
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), notice: 'Successfully updated patient visit detail information.'
		else
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), flash: {error: @patient_visit_detail.errors.full_messages.try(:first)}
		end
	end

	def destroy
		if @patient_visit_detail.can_delete?
			@patient_visit_detail.destroy
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case), notice: 'Successfully destroy patient visit detail information.'		
		else
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case), notice: 'Can not delete patient visit detail.'		
		end
	end

	private

	def patient_visit_detail_params
		params.require(:patient_visit_detail).permit(:patient_visit_id, :procedure_code_id, :amount_in_dollars, :units_sold, :provider_id, :diagnosis_pointer, :place_of_service_code, :patient_owes_reduced_in_dollars, :insurance_owes_reduced_in_dollars, :amount_cents, :patient_owes_cent, :insurance_owes_cents)	
	end

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
		@patient_visit = PatientVisit.find(params[:patient_visit_id])
	end

	def find_patient_visit_detail
		@patient_visit_detail = @patient_visit.patient_visit_details.find(params[:id])
	end

end
