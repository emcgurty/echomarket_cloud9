require 'digest/sha1'
class Participant < ActiveRecord::Base

	belongs_to :user
	has_many :items, :dependent => :destroy
	has_many :addresses, :dependent => :destroy
	has_many :contact_preferences
	has_many :lender_transfers
	has_many :lender_item_conditions
	has_one :alternative_address, :dependent => :destroy
    has_one :primary_address, :dependent => :destroy
    scope :is_a_creator, -> { where(is_creator: 1) }
    scope :is_not_a_creator, -> { where(is_creator: 0) }
    
  	before_create :make_participant_id
  	before_save :set_dates

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	name_alpha_regex = /\A[ a-zA-Z'-]+\z/
	alpha_numeric_regex = /\A[0-9 a-zA-Z:;.,!?'-]+\z/
	alpha_numeric_regex_msg = "must be alphanumeric characters with typical writing punctuation."
	alpha_numeric_regex_username = /\A[0-9 a-zA-Z\-\_]+\z/
  
    attr_accessor  :questionAltEmailProvide, :questionAltEmailDelete,
		 		   :questionAltAddressProvide, :questionAltAddressDelete,
		 		   :alternative_address, :primary_address, :howManyRecords, :current_row, :creator_members, :community_members, :new_member, :email


   # validates  :contact_describe_id, :organization_name, :display_organization, :other_describe_yourself, :first_name , :mi, :last_name,
   # :alias, :display_name, :display_address, :home_phone, :cell_phone, :alternative_phone, :email_alternative, :question_alt_email, :question_alt_address, :display_home_phone, 
   # :display_cell_phone, :display_alternative_phone, :display_alternative_address,  :goodwill, :age_18_or_more, :is_creator :presence => true
   
   	def is_creator?
		self.is_creator == 1
	end 
	
	protected
	
	
	def make_participant_id
	    self.participant_id = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ) 
	end 
    
    def set_dates
	    
		self.approved = 1  ## Just for the moment
		self.created_at = Time.current
		self.date_deleted = Time.current
		self.updated_at = Time.current
    
    end 
   

end
