class PatientBillsController < BaseController
	
	before_action :find_clinic, :find_patient_bill

	def hcfa ## Report Generation
		@hcfa = @patient_bill.hcfa_data
		respond_to do |format|
      format.pdf { render :layout => false }
    end		
	end

	private

	def find_clinic
		@clinic = Clinic.find_by(slug: params[:clinic_id])
	end

	def find_patient_bill
		@patient_bill = current_account.patient_bills.find(params[:id])
	end

end
