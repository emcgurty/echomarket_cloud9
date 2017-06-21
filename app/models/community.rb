class Community < ApplicationRecord
  ## Can't this be empty?
  belongs_to :user
  ## the above is not woorking
  before_create :set_dates
    
  def set_dates
     self.created_at  = Time.current
     self.updated_at  = Time.current
     self.date_deleted = Time.current
  end
end
