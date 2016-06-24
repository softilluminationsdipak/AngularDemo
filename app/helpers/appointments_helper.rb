module AppointmentsHelper
  
  HEIGHT_UNIT = 17
  
  def appt_at(appt, room_id, contact_id, date)
    unless appt.nil?
      appt.contact.name
    else
      ""
    end
  end
  
  def class_if_appt_at(appt, provider_id, date)
    unless appt.nil?
      "appt_active"
    end
  end  
  
  def style_if_appt_at(appt, provider_id, date)
    unless appt.nil?
      "height: " + ((HEIGHT_UNIT * appt.units_15min) + (appt.units_15min == 1 ? 0 : 6 * appt.units_15min)).to_s + "px;"
    end
  end

end
