module Referrerable
  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_referrerable
      belongs_to :referrer, polymorphic: true
    end
  end

  module InstanceMethods
    def p_referrer_id=(r_id)
      pairs = r_id.split('_')
      self.referrer_type = (pairs[0] == 'patient' ? 'Patient' : 'Referrer')
      self.referrer_id = pairs[1]
    end

    def p_referrer_id
      "#{self.referrer_type.downcase if self.referrer_type}_#{self.referrer_id}"
    end
  end	
end