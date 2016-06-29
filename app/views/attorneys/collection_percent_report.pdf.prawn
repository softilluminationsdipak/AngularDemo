prawn_document(page_layout: :landscape) do |pdf|
	pdf.move_down 15
	pdf.text_box("Attorneys - Collection Percentages", size: 17, style: :bold, at: [0, pdf.y])
	pdf.text_box(Date.today.strftime('%d/%m/%Y'), size: 16, at: [pdf.bounds.right - 2.8 * 37, pdf.y], style: :bold)

	pdf.y -= (2 * 37)

	# Headers
	pdf.text_box("Code", at: [0, pdf.y], style: :bold)
	pdf.text_box("Company/Attn:", at: [3*37, pdf.y], style: :bold)
	pdf.text_box("Comments", at: [9*37, pdf.y])

	pdf.y -= (0.5*37)

	pdf.text_box("Collectn%", at: [0, pdf.y], style: :bold)
	pdf.text_box("Patient:", at: [3*37, pdf.y])
	pdf.text_box("Case", at: [6*37, pdf.y])
	pdf.text_box("Total Charge", at: [9*37, pdf.y])
	pdf.text_box("Total Paid", at: [12*37, pdf.y])
	pdf.text_box("Outstanding", at: [14*37, pdf.y])
	pdf.text_box("Collectn. %", at: [16.5*37, pdf.y])
	
	1.times do
		@data.each do |data|
			attorney 			= data[:attorney]
			patient_cases = data[:patient_cases]

			current_line_y = pdf.y - 1*37

			pdf.bounding_box([0, current_line_y], width: 3*37, height: 1*37) do
	    	pdf.text_box(attorney[:code].to_s, size: 9, style: :bold)
	  	end

		  pdf.bounding_box([3*37, current_line_y], width: 6*37, height: 1*37) do
	  	  pdf.text_box(attorney[:company].to_s, size: 9, style: :bold)
	  	end

		  pdf.bounding_box([9*37, current_line_y], width: 9*37, height: 1*37) do
	  	  pdf.text_box(attorney[:comments].to_s, size: 9)
	  	end

	  	patient_cases.each do |patient_case|
		    if current_line_y <= 1*37
		      pdf.start_new_page
		      current_line_y = pdf.bounds.top
		    end

		    current_line_y -= (1*37)

		    pdf.text_box(patient_case[:patient].to_s, at: [3*37, current_line_y])

		    pdf.bounding_box([6*37, current_line_y + 0.24*37], width: 3*37, height: 1*37) do
	  	    pdf.text(patient_case[:case].to_s, size: 9)
	    	end

	    	pdf.text_box(patient_case[:total_charge].to_s, at: [9*37, current_line_y])
		    pdf.text_box(patient_case[:total_paid].to_s, at: [12*37, current_line_y])
	  	  pdf.text_box(patient_case[:outstanding].to_s, at: [14*37, current_line_y])
				pdf.text_box(patient_case[:collectn].to_s, at: [16.5*37, current_line_y])
	  	end
		end
	end	
	pdf.text_box("Note: Percentage formulas are simply Collections/Charges: percentage for Attorney is Sum \ Collections/Sum Charges for all patients in group. Collections and charges do not reflect who paid or \ by whom outstanding is owed these figures reflect case as a whole.", size: 8)
end