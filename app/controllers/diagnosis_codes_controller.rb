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

	def report
	end

	def generate_report
		page_size 		= "A4"
    page_layout 	= :portrait
    column_widths = nil

    case params[:diagnosis_codes_report][:report_type]
    when 'list'
    	title 	= "Diagnosis Codes - List"
    	headers = ["Abbrev", "Code", "Description"]
    	data 		= []
	    
	    current_account.diagnosis_codes.each do |diagnosis_code|
      	data << [ diagnosis_code.name, diagnosis_code.code, diagnosis_code.description ]
    	end

    	if data.blank? || data == []
    		data = [[{:colspan => headers.size, :text => "No data to report about"}]]
    	else
    		list_report(title, headers, data)
    	end
    when 'detailed_usage'
			@data, @total_things = DiagnosisCode.detailed_usage_by_patient(current_account, params[:diagnosis_codes_report][:start_date], params[:diagnosis_codes_report][:end_date])
    	render "detailed_usage.pdf.prawn", layout: false
    when 'summary_of_usage'
      @data, @total_things = DiagnosisCode.usage_by_patient(current_account)
      render "summary_of_usage.pdf.prawn", :layout => false    	
    end
	end
	
	private

	def list_report(title, headers, data)
		rand = SecureRandom.hex(10)
		name = "diagnosis_codes_report_#{rand}.pdf"
		Prawn::Document.generate("public/reports/#{name}", page_size: 'A4', page_layout: :portrait) do
			draw_text(title, size: 18, style: :bold, at: [0, bounds.top])
			draw_text(Date.current, size: 16, style: :bold, at: [12 * 37, bounds.top])
      move_down 1 * 37
      data2 = [headers]
      data2 += data
      table(data2, cell_style: { font_size: 10, align_headers: :left, font_size: 10, align: :left, column_widths: nil, border_width: 0 })
		end
		redirect_to "/reports/#{name}"
	end

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
		when 'report'
			add_breadcrumb 'Report'
		end		
	end

	def diagnosis_code_params
		params.require(:diagnosis_code).permit(:name, :code, :description, :clinic_id, :account_id)
	end

end
