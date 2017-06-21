class ContactPreference < ApplicationRecord
    
     belongs_to :participant
     attr_accessor :display_alternative_email, :user_id, :preference_field_changed
     before_save :set_dates
     
     private
     
     def set_dates
       self.created_at  = Time.current
       self.updated_at  = Time.current
       self.date_deleted = Time.current  ##  need to change database, shouldn't be required
     end     
end
