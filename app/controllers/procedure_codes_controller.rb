class ProcedureCodesController < BaseController

	before_filter :find_clinic
	before_filter :find_procedure_code, only: [:edit, :update, :show, :destroy]
	
	add_breadcrumb "Home", :user_dashboard_path

	def index
		return redirect_to new_clinic_path, flash: {error: 'Kindly create clinic to manage patients.'} if current_account.clinics.count == 0
		return redirect_to clinic_procedure_codes_path(current_account.try(:clinics).try(:latest).try(:first)) unless @clinic.present?
		
		add_breadcrumb "Procedure Code", clinic_procedure_codes_path(@clinic)
		
		if @clinic.present?
			@procedure_codes 	= @clinic.procedure_codes
		else
			@clinic 					= current_account.clinics.latest.first
			@procedure_codes 	= @clinic.procedure_codes
		end		
	end

	def new
		add_breadcrumb "Procedure Code", clinic_procedure_codes_path(@clinic)
		add_breadcrumb 'New Procedure Code', new_clinic_procedure_code_path(@clinic)

		@procedure_code = @clinic.procedure_codes.build
		prepare_fee_schedule
	end

	def create
		add_breadcrumb "Procedure Code", clinic_procedure_codes_path(@clinic)
		add_breadcrumb 'New Procedure Code', new_clinic_procedure_code_path(@clinic)

		@procedure_code = @clinic.procedure_codes.build(procedure_code_params)
		if @procedure_code.save
			redirect_to clinic_procedure_codes_path(@clinic), flash: {success: 'Successfully created procedure code.'}
		else
			render action: :new
		end
	end

	def edit		
		add_breadcrumb "Procedure Codes", clinic_procedure_codes_path(@clinic)
		add_breadcrumb 'Edit Procedure Code'
		prepare_fee_schedule
	end

	def show
		add_breadcrumb "Procedure Codes", clinic_procedure_codes_path(@clinic)
		add_breadcrumb @procedure_code.name
	end

	def update		
		add_breadcrumb "Procedure Code", clinic_procedure_codes_path(@clinic)
		add_breadcrumb 'Edit Procedure Code'

		if @procedure_code.update_attributes(procedure_code_params)
			redirect_to clinic_procedure_codes_path(@clinic), flash: {success: 'Successfully updated procedure code.'}
		else
			render action: :edit
		end
	end

	def destroy
		@procedure_code.destroy if @procedure_code.present?
		respond_to do |format|
			format.html{redirect_to clinic_procedure_codes_path(@clinic), notice: 'Successfully deleted procedure code.'}
			format.json{ render json: @procedure_code}
		end		
	end

	def type_code_selected
		respond_to do |format|
			format.html{render nothing: true}
			format.js
		end
	end

	private

	def procedure_code_params
		params.require(:procedure_code).permit(:id, :name, :description, :cpt_code, :tax_rate_percentage, :modifier, :modifier2, :modifier3, :type_code, :service_type_code, procedure_codes_fee_schedule_labels_attributes: [:id, :fee_schedule_label_id, :fee_cents, :fee_in_dollars, :copay, :is_percentage, :expected_insurance_payment_cents, :expected_insurance_payment_in_dollars, fee_schedule_label_attributes: [:id, :clinic_id, :label, :account_id] ])
	end

	def find_clinic
		@clinic = current_account.clinics.find_by(slug: params[:clinic_id])
	end

	def find_procedure_code
		@procedure_code = @clinic.procedure_codes.find_by(slug: params[:id])
	end

	def prepare_fee_schedule
    @procedure_code.preload_existing_fee_schedules
    fee_schedule = @procedure_code.procedure_codes_fee_schedule_labels.build
    fee_schedule.build_fee_schedule_label(clinic_id: @procedure_code.clinic_id)		
	end


end
