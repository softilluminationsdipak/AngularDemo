require 'csv'
class Letter < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  ## Relationship
  acts_as_paranoid
  
  belongs_to :account

  ## Validations
  validates :name, presence: true, uniqueness: {scope: :account_id}
  validates :body, presence: true

  ## Scopes
  scope :latest, -> { order('created_at DESC')}
  
  ## Methods
  def self.import(file, current_account)
    letters = []
    messages = []
    begin
      CSV.foreach(file.path, quote_char: '"', col_sep: ',', row_sep: :auto, headers: true) do |row|        
        new_letter = Letter.create({
          name: row[0],
          body: row[1].gsub("  ", "\n"),
          account_id: current_account.id
        })
        letters << new_letter
        messages << new_letter.errors.full_messages
      end
    rescue
    end
    return letters, messages
  end

  def display_created_at
    updated_at.strftime('%a, %d %b %Y - %H:%M %p')
  end

end
