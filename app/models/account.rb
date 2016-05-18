class Account < ActiveRecord::Base

	## Relationship
	has_many :users, dependent: :destroy
	has_many :admin, -> { where admin: true }, class_name: 'User'
  has_many :clinics, dependent: :destroy
  has_many :providers, through: :clinics
  
	## Validations
	validates :name, presence: true
	validates :full_domain, format: { with: /\A[a-zA-Z][a-zA-Z0-9]*\Z/ }, on: :create
	validates :full_domain, exclusion: { in: %w(support blog www billing help api #{AppConfig['admin_subdomain']} ), message: "The domain %{value} is not available." }

	validate :valid_domain?

  ## Callbacks
  before_create :set_full_domain_name
	
	protected

  def valid_domain?
    conditions = self.new_record? ? ['full_domain = ?', self.full_domain] : ['full_domain = ? and id <> ?', self.full_domain, self.id]
    if new_record?
    	if self.full_domain.blank? || self.class.where('full_domain = ?', self.full_domain).count > 0
    		self.errors.add(:full_domain, 'is not available')
    	end
    else
    	if self.full_domain.blank? || self.class.where('full_domain = ? and id <> ?', self.full_domain, self.id).count > 0
    		self.errors.add(:full_domain, 'is not available')
    	end
    end
  end

  def set_full_domain_name
    self.full_domain = "#{full_domain}.#{AppConfig['base_domain'].gsub(/(:\d+)$/, '')}"
  end

end
