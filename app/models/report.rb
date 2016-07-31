class Report

  BALANCE_OPTIONS 	= ["Anything but Zero", "More than Zero", "Less than Zero", "Zero", "Don't Care"]
  CATEGORIES 		= ["", "aug07", "mw", "OH", "oxref", "ss", "wls"]
  TYPES 			= []

  def self.accounts(account)    
    account.patients.order('account_code ASC').map(&:account_code)
  end

  def self.names(account)    
    account.patients.alphabetically.map(&:full_name)
  end

  def self.zip_codes(account)
    account.patients.includes([:address, :contact]).references([:address, :contact]).map(&:address).map(&:zipcode).uniq
  end
	
  def self.insurance_carriers(account)
    account.insurance_carriers.order('name ASC').map(&:name)
  end

  def self.attorneys(account)
  	account.attorneys.includes(:contact).references(:contact).map(&:contact).map(&:company_name)
  end

  def self.doctors(account)
    account.providers.order('signature_name ASC').map(&:signature_name)
  end

  def self.insurance_types
    AppConfig["options"]["carrier_types"].keys
  end

  def self.fee_schedules
    FeeScheduleLabel.order('label ASC').map(&:label)
  end

end