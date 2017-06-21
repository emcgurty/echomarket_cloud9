class Address < ApplicationRecord
 belongs_to :participant
 scope :primary_address, -> { where(address_type:'primary') }
 scope :alternative_address, -> { where(address_type: 'alternative') }
 belongs_to :country
 belongs_to :us_state
 
 

 validates  :postal_code, :presence => true 

 
end
