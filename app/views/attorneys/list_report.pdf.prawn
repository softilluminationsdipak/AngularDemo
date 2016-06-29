prawn_document(page_layout: :landscape) do |pdf|
	pdf.move_down 15
	pdf.text_box("Attorneys List", size: 17, style: :bold, at: [0, pdf.y])
	pdf.text_box(Date.today.strftime('%d/%m/%Y'), size: 16, at: [pdf.bounds.right - 2.8 * 37, pdf.y], style: :bold)

	pdf.move_down 20
	pdf.font_size 9
	pdf.table(@data, header: true, column_widths: [100, 120, 120, 80, 80, 250]) do
		cells.padding = 5
 		row(0).border_width = 2
 		row(0).font_style = :bold
	end

end