class PatientReportsController < BaseController
	def index
	end

	def create
		page_size 		= "A4"
    page_layout 	= :portrait
    column_widths = nil

    case params[:patient_report][:report_type]
    when "all_patients"
    	headers = ["Account", "Name", "Appt?", "Last Visit", "Phone", "WorkPhone", "Inactive"]
    	data = PatientReport.all_patients(current_account)
    	title = "Short List of All Patients"
    when "financial"
    	headers = ["Account", "Name", "Last OV", "Last Pay", "Statmt", "Balance", "Ins Owes", "Pat. Owes"]
    	title 	= "Short Financial List"
    	data 		= PatientReport.financial(current_account)
    when "birthdays"
    	headers = ["Account", "Name", "Appt?", "Birthday", "Phone", "WorkPhone", "Inactive"]
    	title 	= "Short List of Birthdays"
    	data 		= []
    when "new_patients"
    	headers = ["Account", "Name", "Appt?", "First Visit", "Phone", "WorkPhone", "Inactive", "V#"]
    	title 	= "Short List of New Patients"
    	data 		= []
    when "last_visit"
    	headers = ["Account", "Name", "Appt?", "Last Visit", "Phone", "WorkPhone", "Inactive"]
    	title 	= "Short List of Last Visits"
    	data 		= []
    when "last_x_ray"
    	headers = ["Account", "Name", "Appt?", "Last X-Ray", "Phone", "WorkPhone", "Inactive"]
    	title 	= "Short List of Last X-Rays"
    	data 		= []
    when "patients_attorneys"
    	headers = ["Name", "Account", "Phone", "WorkPhone", "LastVisit", "Onset", "Policy-Group", "Guar", "InsOwes", "PatOwes", "Total"]
    	title 	= "Patients List by Attorney"
    	data 		= []
    	page_layout = :landscape
    when "patients_insurance_carriers"
    	headers = ["Name", "Account", "Phone", "WorkPhone", "LastVisit", "Onset", "Policy-Group", "Guar", "InsOwes", "PatOwes", "Total"]
    	title 	= "Patients List by Insurance Carrier"
    	page_layout = :landscape
    	data 		= []
    when "authorized_through"
    	headers = ["Account", "Name", "Last OV", "Last Pay", "Statmt", "Balance", "Ins Owes", "Pat. Owes"]
    	title 	= "Short Financial List"
    	data 		= []
    when "letters"
    	title 	= "Letters"    	
    	data 		= []
  	end
  	data = [[{:colspan => headers.size, :content => "No data to report about"}]] if data == []
  	report(title, headers, data, page_size, page_layout, column_widths)	
	end

	private
	
	def report(title, headers, data, page_size="A4", page_layout=:portrait, column_widths=nil)
		rand = SecureRandom.hex
		name = "patients_report_#{rand}.pdf"

		Prawn::Document.generate("public/reports/#{name}", :page_size => page_size, :page_layout => page_layout) do |pdf|    	
      pdf.text_box(title, size: 14, style: :bold, at: [0, 780])
      pdf.text_box(Time.zone.now.strftime('%d/%m/%Y'), size: 12, style: :bold, at: [12*36, 780])
      pdf.move_down 1*37
      data2 = [headers] + data
      pdf.font_size 10	      
      logger.warn("==data===#{data.inspect}================")
      pdf.table(data2, cell_style: { font_size: 7, align_headers: :left, align: :left, column_widths: nil, border_width: 0 })
    end

    redirect_to "/reports/#{name}"		
	end

end
