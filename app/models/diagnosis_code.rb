require 'csv'
class DiagnosisCode < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

	## Relationships
	belongs_to :account
	belongs_to :clinic

	has_many :patient1_cases, class_name: 'PatientCase', foreign_key: 'diagnosis1_id'
  has_many :patient2_cases, class_name: 'PatientCase', foreign_key: 'diagnosis2_id'
  has_many :patient3_cases, class_name: 'PatientCase', foreign_key: 'diagnosis3_id'
  has_many :patient4_cases, class_name: 'PatientCase', foreign_key: 'diagnosis4_id'

  has_many :patient1_visits, class_name: 'PatientVisit', foreign_key: 'diagnosis1_id'
  has_many :patient2_visits, class_name: 'PatientVisit', foreign_key: 'diagnosis2_id'
  has_many :patient3_visits, class_name: 'PatientVisit', foreign_key: 'diagnosis3_id'
  has_many :patient4_visits, class_name: 'PatientVisit', foreign_key: 'diagnosis4_id'

	## Scopes
	scope :alphabetically, -> { order('name ASC') }
  scope :ascend_by_name, -> { order('name ASC') }
  scope :ascend_by_code, -> {order('code ASC')}
  scope :ascend_by_description, -> {order('description ASC')}

	## Validations
	validates :name, :code, :description, presence: true
	validates :name, length: { maximum: 20 }

	## Constant
	REPORT_TYPES 	= { summary_of_usage: 'Summary of Usage by Patient', detailed_usage: 'Detailed Usage by Patient', list: 'List' }
  ORDERS 				= { name: 'Name', code: 'Code Number', description: 'Description' }
  DATES_FORMAT 	= /\A\d{2}\/\d{2}\/\d{4}\z/
	
  def display_created_at
    updated_at.strftime('%a, %d %b %Y - %H:%M %p')
  end

  def self.import_patient_from_file(file, clinic, account)
  	row_num = 0
  	error = nil
		begin		  					
			CSV.foreach(file, quote_char: '"', col_sep: ',', row_sep: :auto) do |row|
				row_num += 1				
	      dc = DiagnosisCode.new({ name: row[0], code: row[1], description: row[2], clinic_id: clinic.id, account_id: account.id })
	      if dc.valid?
	      	dc.save
	      	next if row_num == 1
	      else
	      	error = dc.errors.full_messages.try(:first)
	      end
			end
			return !error.present?, error.present? ? error : 'success'
		rescue Exception => e
			return false, e		
		end  	
  end

  def dropdown_title
    "#{code} - #{name} - #{description}"
  end

  def title
    "#{name} - #{code} - #{description}"
  end

  def self.ordered_diagnosis_codes(current_account, diagnosis_list_order=nil)
  	diagnosis_list_order = 'name' if diagnosis_list_order.nil?
    current_account.diagnosis_codes.send("ascend_by_" + { name: 'name', code: 'code', description: 'description' }[diagnosis_list_order.to_sym] )
  end

	def self.sorting_method(diagnosis_list_order=nil)
		diagnosis_list_order = 'name' if diagnosis_list_order.nil?
    { name: 'name', code: 'code', description: 'description'}[diagnosis_list_order.to_sym]
  end

  def self.detailed_usage_by_patient(current_account, start_date=nil, end_date=nil)
  	start_date = Time.zone.now.to_date unless start_date.present?
  	end_date = Time.zone.now.to_date unless start_date.present?

		d = current_account.diagnosis_codes.includes(:patient1_visits, :patient2_visits, :patient3_visits, :patient4_visits).where("DATE(patient_visits.visited_at) between ? AND ?", start_date.to_date, end_date.to_date).references(:patient1_visits, :patient2_visits, :patient3_visits, :patient4_visits)
    data, count_things = DiagnosisCode.prepare_data_for_usage_by_patient(d, 'patient1_visits', 'patient2_visits', 'patient3_visits', 'patient4_visits')
  end

  def self.usage_by_patient(current_account)
  	d = current_account.diagnosis_codes.includes(:patient1_cases, :patient2_cases, :patient3_cases, :patient4_cases).references(:patient1_cases, :patient2_cases, :patient3_cases, :patient4_cases)
    data, count_things =  DiagnosisCode.prepare_data_for_usage_by_patient(d, 'patient1_cases', 'patient2_cases', 'patient3_cases', 'patient4_cases')
  end

  def self.prepare_data_for_usage_by_patient(dcodes, patient1_thing, patient2_thing, patient3_thing, patient4_thing)
    data = []

    # #calculate count of patient cases/visits
    count_things = 0
    if dcodes.present?    	
	    dcodes.each do |diagnosis_code|
	      count_things += diagnosis_code.send(patient1_thing).size
	      count_things += diagnosis_code.send(patient2_thing).size
	      count_things += diagnosis_code.send(patient3_thing).size
	      count_things += diagnosis_code.send(patient4_thing).size
	    end

	    dcodes.each do |diagnosis_code|
	      patient_things = []
	      patient_things += diagnosis_code.send(patient1_thing)
	      patient_things += diagnosis_code.send(patient2_thing)
	      patient_things += diagnosis_code.send(patient3_thing)
	      patient_things += diagnosis_code.send(patient4_thing)

	      data << {
	        :diagnosis_code => diagnosis_code,
	        :count_things   => patient_things.size,
	        :percents       => ((count_things > 0) ? (patient_things.size*100/count_things) : 0),
	        :patient_things => patient_things
	      }
	     
	    end
	  end
    [data, count_things]
  end

end
