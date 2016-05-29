class DiagnosisCodesController < BaseController
  expose(:diagnosis_codes) { current_account.diagnosis_codes }	
	expose(:diagnosis_code, attributes: :diagnosis_code_params, finder: :find_by_slug)

	before_filter :set_breadcrum

	def create
		if diagnosis_code.save
			redirect_to diagnosis_codes_path, flash: {success: 'Successfully created diagnosis code.'}
		else
			render action: :new
		end
	end

	def update
		if diagnosis_code.update_attributes(diagnosis_code_params)
			redirect_to diagnosis_codes_path, flash: {success: 'Successfully updated diagnosis code.'}
		else
			render action: :edit
		end
	end

	def destroy
		diagnosis_code.destroy if diagnosis_code.present?
		respond_to do |format|
			format.html{redirect_to diagnosis_codes_path, notice: 'Successfully deleted diagnosis code.'}
			format.json{ render json: diagnosis_code}
		end		
	end

	def import_data
		clinic = current_account.clinics.find_by(slug: params[:clinic_id])
    if params[:file].present? 
    	response, error = DiagnosisCode.import_patient_from_file(params[:file].path, clinic, current_account)
    	if response == true
      	redirect_to diagnosis_codes_path, flash: {success: 'Diagnosis codes have been successfully imported'}
      else
      	flash[:error] = error
      	render action: :import
      end
    else
      flash[:error] = 'Check file, it should be csv format'
      render 'import'
    end
	end

	private

	def set_breadcrum
		add_breadcrumb "Home", user_dashboard_path
		add_breadcrumb "Diagnosis Codes", diagnosis_codes_path
		case params[:action].to_s
		when 'new' || 'create'
			add_breadcrumb 'New Diagnosis Code', new_diagnosis_code_path
		when 'edit' || 'Update'
			add_breadcrumb 'Edit Diagnosis Code', edit_diagnosis_code_path(diagnosis_code)
		when 'show'
			add_breadcrumb diagnosis_code.name, diagnosis_code_path(diagnosis_code)
		when 'import'
			add_breadcrumb 'Import'
		end		
	end

	def diagnosis_code_params
		params.require(:diagnosis_code).permit(:name, :code, :description, :clinic_id, :account_id)
	end

end
