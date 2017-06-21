require 'digest/sha1'
class Search < ApplicationRecord
    
    attr_accessor :found_zip_codes, :selection_made
    before_create :make_id 
    validates_uniqueness_of :search_name,:if => :search_name, :case_sensitive => true, :message =>  " already exists",scope: [:user_id]
    
    
    def make_id
	    self.id = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	    self.created_at = Time.current
	   
    end 
    
    
    
    
    
    
end
