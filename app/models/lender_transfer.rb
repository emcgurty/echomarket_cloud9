require 'digest/sha1'
class LenderTransfer < ApplicationRecord
belongs_to :participant
attr_accessor :transfer_field_changed
before_create :make_id  

 protected
	
	def make_id
	    self.lender_transfer_id = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end 
end
