require 'csv'
class DiagnosisCode < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

	## Relationships
	belongs_to :account
	belongs_to :clinic

	## Scopes
	scope :alphabetically, -> { order('name ASC') }

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

end
