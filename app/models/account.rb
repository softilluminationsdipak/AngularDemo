class Account < ActiveRecord::Base

	## Relationship
	has_many :users, dependent: :destroy
	has_many :admin, -> { where admin: true }, class_name: 'User'
  has_many :clinics, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :letters, dependent: :destroy
  has_many :insurance_carriers, dependent: :destroy
  has_many :attorneys, dependent: :destroy
  
	## Validations
	validates :name, presence: true
	validates :domain, format: { with: /\A[a-zA-Z][a-zA-Z0-9]*\Z/ }
	validates :domain, exclusion: { in: %w(support blog www billing help api #{AppConfig['admin_subdomain']} ), message: "The domain %{value} is not available." }

	validate :valid_domain?

  ## Callbacks
  before_save :set_full_domain_name

  ## Scopes
  scope :latest, -> { order('created_at DESC')}

	protected

  def valid_domain?
    conditions = self.new_record? ? ['domain = ?', self.domain] : ['domain = ? and id <> ?', self.domain, self.id]
    if new_record?
    	if self.domain.blank? || self.class.where('domain = ?', self.domain).count > 0
    		self.errors.add(:domain, 'is not available')
    	end
    else
    	if self.domain.blank? || self.class.where('domain = ? and id <> ?', self.domain, self.id).count > 0
    		self.errors.add(:domain, 'is not available')
    	end
    end
  end

  def set_full_domain_name
    self.full_domain = "#{domain.downcase}.#{AppConfig['base_domain'].gsub(/(:\d+)$/, '')}"
  end

end
