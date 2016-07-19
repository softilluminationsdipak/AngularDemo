prawn_document(page_layout: :landscape) do |pdf|
	pdf.text("Appointments for " + @data[:date].to_s)
	pdf.move_down 2*13
	@data[:appointments].each do |appointment|
  	pdf.text(appointment.to_s)
	end	
end