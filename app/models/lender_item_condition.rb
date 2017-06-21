require 'digest/sha1'
class LenderItemCondition < ApplicationRecord
belongs_to :participant
attr_accessor :condition_field_changed    

end
