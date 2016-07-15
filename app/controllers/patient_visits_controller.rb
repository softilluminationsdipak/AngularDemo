class PatientVisitsController < BaseController
	
	before_action :find_patient_case, :find_patient, :find_clinic
	before_action :find_patient_visit, only: [:show, :edit, :update, :destroy, :pull_from_case, :push_to_case, :diagnoses, :report_option, :receipt_report, :generate_report]

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
		if params[:patient_visit] && @patient_visit.update_attributes(patient_visit_params)
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), notice: 'Successfully updated patient visit information.'
		else
			if @patient_visit.errors.present?
				redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id ), flash: {error: @patient_visit.errors.full_messages.join(', ')}
			else
				redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case, patient_visit_id: @patient_visit.id)
			end
		end
	end

	def destroy
		if @patient_visit.can_delete?
			@patient_visit.destroy
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case), notice: 'Successfully destroy patient visit information.'
		else
			redirect_to clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case), notice: "Can't destroy patient visit information."
		end
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

  def pull_from_case
  	@patient_visit.pull_from_case
  	respond_to do |format|
  		format.html{render nothing: true}
  		format.js
  		format.json{render json: @patient_visit}
  	end
  end

  def push_to_case
  	@patient_visit.push_to_case
  	respond_to do |format|
  		format.html{render nothing: true}
  		format.js
  		format.json{render json: @patient_visit}
  	end  	
  end

  def diagnoses
		add_breadcrumb "Patients", clinic_patients_path(@clinic)
		add_breadcrumb 'Patient Cases', clinic_patient_patient_cases_path(@clinic, @patient)		
		add_breadcrumb 'Patient Visit', clinic_patient_patient_case_patient_visits_path(@clinic, @patient, @patient_case)
		add_breadcrumb 'Diagnoses'
  end

  def report_option
  end

  def receipt_report
  	if request.get?
  		@patient_visits = @patient_case.patient_visits
  	else
			page_size 		= "A4"
	    page_layout 	= :portrait
	    column_widths = nil
	    fees 					= nil
			title 				= "Receipt report"
			headers 			= ["Description", "CPT code", "Units", "Service", "Paid", "Adjust", "Balance"]
			fees, data 		= PatientVisit.report(params[:patient_visit_id], params)
			report(title, headers, data, page_size, page_layout, column_widths, fees)
  	end
  end

  def generate_report
  	@bills = []
  	case params[:report_type].to_i
  	when 0
  		patient_case = PatientCase.find(params[:patient_case_id])
  		@bills = patient_case.create_bills(current_account)
  	when 1
  		patient_case = PatientCase.find(params[:patient_case_id])
  		@bills = patient_case.create_bills(current_account)
  	when 2
  		patient_case = PatientCase.find_by(slug: params[:patient_case_id])
  		@bills = patient_case.create_bills(current_account)
  	when 3
  		redirect_to receipt_report_clinic_patient_patient_case_patient_visit_path(@clinic, @patient, @patient_case, @patient_visit)
  	when 4
  		redirect_to receipt_report_clinic_patient_patient_case_patient_visit_path(@clinic, @patient, @patient_case, @patient_visit)
  	else
  		redirect_to receipt_report_clinic_patient_patient_case_patient_visit_path(@clinic, @patient, @patient_case, @patient_visit)
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
		if params[:patient_visit].present?
			params.require(:patient_visit).permit(:patient_case_id, :visited_at, :fee_slip_number, :onset_at, :first_treated_at, :should_bill_primary, :should_bill_secondary, :should_bill_attorney, :diagnosis1_id, :diagnosis2_id, :diagnosis3_id, :diagnosis4_id, :details, :diagnosis1_description, :diagnosis2_description, :diagnosis3_description, :diagnosis4_description, :primary_patient_bill_id, :secondary_patient_bill_id, :attorney_patient_bill_id)
		end
	end

	def report(title, headers, data, page_size="A4", page_layout=:portrait, column_widths=nil, fees=nil)
		rand = SecureRandom.hex
		name = "receipt_report_#{rand}.pdf"

		Prawn::Document.generate("public/reports/#{name}", :page_size => page_size, :page_layout => page_layout) do |pdf|

      pdf.bounding_box([1, 780], width: 300, height: 70) do
        pdf.text_box(data[:title], size: 10, style: :bold)
  			pdf.text_box(data[:title2], size: 10, style: :bold)
      end

      pdf.text_box("Date \n" + data[:date], size: 10, style: :bold, at: [10*37, 780])

			unless fees.nil?
				fees_with_headers = [headers] + fees				
				pdf.table(fees_with_headers, cell_style: { size: 7, align: :left, column_widths: column_widths, border_width: 1,  at: [14*32, 780]} )
			end

			pdf.move_down (1*32)

			pdf.text_box(data[:onset], size: 10, at: [0, pdf.move_down(1*32)])
			pdf.text_box(data[:first_treatment], size: 10, at: [0, pdf.move_down(1*32)])
			if data[:visit_patient_owes].present?
				pdf.text_box(data[:visit_patient_owes], size: 10, at: [0, pdf.move_down(1*32)])
			end
			if data[:account_balance].present?
				pdf.text_box(data[:account_balance], size: 10, at: [0, pdf.move_down(1*32)])
			end
			pdf.text_box(data[:account_patient_owes], size: 10, at: [0, pdf.move_down(1*32)])
			pdf.text_box("Diagnosis information:", size: 10, style: :bold, at: [0, pdf.move_down(1*32)])
			pdf.text_box(data[:diagnosis1], size: 10, at: [0, pdf.move_down(1*32)])
			pdf.text_box(data[:diagnosis2], size: 10, at: [0, pdf.move_down(1*32)])
			pdf.text_box(data[:diagnosis3], size: 10, at: [0, pdf.move_down(1*32)])
			pdf.text_box(data[:diagnosis4], size: 10, at: [0, pdf.move_down(1*32)])
		end
		redirect_to "/reports/#{name}"
	end
end
