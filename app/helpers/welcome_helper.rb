module WelcomeHelper
	def custom_pluralize(count, string)
		if count.to_i >= 2
			"#{string}s"
		else
			"#{string}"	
		end
	end	

	## Display Error Message On Fields
  def display_error_messages(errors, fields = [])
    error_message = []
    fields.each do |field|
      field_name = field.to_s.split('.').last
      errors.messages[field].each { |error| error_message <<  "#{field_name.to_s.humanize} #{error}" } if errors.messages[field]
    end
    if error_message.size > 1
      (error_message.empty?) ? '' : "#{error_message.first}"
    else
      (error_message.empty?) ? '' : "#{error_message.join(', ')}"
    end
  end
	
end
