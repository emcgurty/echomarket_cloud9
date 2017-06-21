class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  # GET /participants
  # GET /participants.json
  def index
  end

  def update_details
    logger.debug "UPDATE DETAILS"
    @hold = nil
    @deactivate_user = -9
    
    unless params[:participant][:participant][:participant_changed].blank? 
      if params[:participant][:participant][:participant_changed].to_i == 1
        @participant = update_participant
        session[:partID] = true
      end
    end 
    
    if params[:participant][:lender_item_condition]
    unless params[:participant][:lender_item_condition][:condition_changed].blank? 
      if params[:participant][:lender_item_condition][:condition_changed].to_i == 1
        @lender_item_condition = update_condition
      end
    end 
    end

    if params[:participant][:lender_transfer]

    unless params[:participant][:lender_transfer][:transfer_changed].blank? 
      if params[:participant][:lender_transfer][:transfer_changed].to_i == 1
        @lender_transfer = update_transfer
      end
    end 
    end
    
    unless params[:participant][:user][:user_changed].blank? || params[:participant][:user][:user_id].blank?
       if params[:participant][:user][:user_changed].to_i == 1
        unless params[:participant][:user][:delete_user].blank?
           @deactivate_user = params[:participant][:user][:delete_user].to_i
           if @deactivate_user == 1
             @user = User.find_by(user_id: params[:participant][:user][:user_id].to_s)
             @user.is_active = 0
             @user.save(:validate => false)
             
           end   
        end
        
        unless params[:participant][:user][:user_password_changed].blank? || @deactivate_user == 1
           @password_changed = params[:participant][:user][:user_password_changed].to_i
           
        end
        ##  Need to test new user information... Otherwise  this is not complete.  Need to write params for User
        if @password_changed == 0
           @user = User.find_by(user_id: params[:participant][:user][:user_id].to_s)
           @hold = params[:participant][:user]
           @user.community_name =  @hold[:community_name]
           @user.username =  @hold[:username]
           @user.email =  @hold[:email]
           @user.user_alias =  @hold[:user_alias]
           @user.user_type = delimit_user_type(@hold[:user_type])
           @user.save(:validate => false)
           
        elsif @password_changed == 1
          @hold = params[:participant][:user]
          if @hold[:password] == @hold[:password_confirmation]
             @user = User.find_by(user_id: params[:participant][:user][:user_id].to_s)
             @user.community_name =  @hold[:community_name]
             @user.username =  @hold[:username]
             @user.email =  @hold[:email]
             @user.user_alias =  @hold[:user_alias]
             @user.user_type = delimit_user_type(@hold[:user_type])
             @user.password = @hold[:password]
             @user.password_confirmation = @hold[:password_confirmation]
             @user.save(:validate => false)
             flash.notice = "Your User Login Information has been updated with a password change"
          else
             flash.notice = "Update of User Login Information failed becuase you did not provide matching paswords... Please try again."
             @user = User.find_by(user_id: params[:participant][:user][:user_id].to_s)
          end   
        end
       
       end
    end 
    if params[:participant][:community]
    unless params[:participant][:community][:community_changed].blank? || params[:participant][:community][:community_id].blank?
      if params[:participant][:community][:community_changed].to_i == 1
        @community = Community.find_by(community_id: params[:participant][:community][:community_id].to_s)
        @hold = params[:participant][:community]
        @community.update(user_id: @hold[:user_id],community_name: @hold[:community_name], 
           email: @hold[:email], first_name: @hold[:first_name], mi: @hold[:mi], last_name: @hold[:last_name], 
           address_line_1: @hold[:address_line_1], address_line_2: @hold[:address_line_2], 
           city: @hold[:city], us_state_id: @hold[:us_state_id] , province: @hold[:province], region: @hold[:region],  
           postal_code: @hold[:postal_code] , country_id: @hold[:country_id], 
           cell_phone: @hold[:cell_phone] , home_phone: @hold[:home_phone], 
           is_active: 1)
           
      end
    end 
  end
    
      unless params[:participant][:contact_preference][:preference_changed].blank? || params[:participant][:contact_preference][:participant_id].blank?
      if params[:participant][:contact_preference][:preference_changed].to_i == 1
        @part = Participant.find_by(participant_id: params[:participant][:contact_preference][:participant_id].to_s)
        @cp = params[:participant][:contact_preference]
        if params[:participant][:contact_preference][:contact_preference_id].blank?
          @contact_preference = @part.contact_preferences.create(item_id: @cp[:item_id], user_id: @cp[:user_id], use_which_contact_address: @cp[:use_which_contact_address ], 
           contact_by_chat: @cp[:contact_by_chat ],  contact_by_email: @cp[:contact_by_email],  
           contact_by_home_phone: @cp[:contact_by_home_phone ], contact_by_cell_phone: @cp[:contact_by_cell_phone ],   
           contact_by_alternative_phone: @cp[:contact_by_alternative_phone ],  
           contact_by_Facebook: @cp[:contact_by_Facebook ], contact_by_Twitter: @cp[:contact_by_Twitter ],  
           contact_by_Instagram: @cp[:contact_by_Instagram ], contact_by_LinkedIn: @cp[:contact_by_LinkedIn ],   
           contact_by_other_social_media: @cp[:contact_by_other_social_media ],   contact_by_other_social_media_access: @cp[:contact_by_other_social_media_access])
           session[:cpId] = true             
        else
          @contact_preference = @part.contact_preferences.update(item_id: @cp[:item_id], user_id: @cp[:user_id], use_which_contact_address: @cp[:use_which_contact_address ], 
           contact_by_chat: @cp[:contact_by_chat ],  contact_by_email: @cp[:contact_by_email],  
           contact_by_home_phone: @cp[:contact_by_home_phone ], contact_by_cell_phone: @cp[:contact_by_cell_phone ],   
           contact_by_alternative_phone: @cp[:contact_by_alternative_phone ],  
           contact_by_Facebook: @cp[:contact_by_Facebook ], contact_by_Twitter: @cp[:contact_by_Twitter ],  
           contact_by_Instagram: @cp[:contact_by_Instagram ], contact_by_LinkedIn: @cp[:contact_by_LinkedIn ],   
           contact_by_other_social_media: @cp[:contact_by_other_social_media ],   contact_by_other_social_media_access: @cp[:contact_by_other_social_media_access])
                       
        end  
        
      end
      end 
    
    if params[:participant][:user][:user_changed].to_i == 1 || @deactivate_user == 1
   
        reset_session
        if params[:participant][:user][:user_changed].to_i == 1
          flash.notice = "Your login information has been changed, please login." 
        end
        if  @deactivate_user == 1
         flash.notice = "Your Echomarket Account has been deactivated."
        end  
        
        session[:user_action] = 'userLogin'
        render :template => 'users/app_options'
    
      
    else
   
      is_user_signed_in("part/update_details")
     # @editable = 1
      #@participant = Participant.find_by(participant_id: getParticipantID)
      #render :template => 'participants/main_user_detail', 
      #:locals => {participant: @participant, contact_preference: @contact_preference, user: @user,
      #  lender_transfer: @lender_transfer, lender_item_condition: @lender_item_condition, editable: @editable      }
      redirect_to :controller => 'participants', :action => "show", :id => 'main_user_detail'
    end  
    
  end
  
  def update_members
    
      @how_many_hold = 0
      @how_many = 0
      @flashNotice = nil
      @processDone = false
      
    unless params[:participants][:community_members][:action].blank?          
        logger.debug "HERE 1"
      if params[:participants][:community_members][:action].to_s == 'edit'
        logger.debug "HERE 11"          
          @p = Participant.find_by(community_id: params[:participants][:community_members][:community_id].to_s, 
                           participant_id: params[:participants][:community_members][:participant_id].to_s)
          if @p.update(editable: 1)
            @processDone = true
          end  
      elsif params[:participants][:community_members][:action].to_s == 'update'
        logger.debug "HERE 33"
         @p_params = params[:participants][:community_members]
         @participant = Participant.find_by(participant_id: @p_params[:participant_id])
         if @participant.update(first_name: @p_params[:first_name], last_name: @p_params[:last_name], alias: @p_params[:alias],
                             is_creator: @p_params[:is_creator], is_active: @p_params[:is_active], editable: 0)
            @processDone = true                 
         end
      end        
  
    end
      
      unless params[:cancel].blank?          
        logger.debug "HERE 61"
        if params[:cancel].to_s == 'Cancel'
        logger.debug "HERE 6611"          
          @p = Participant.where(community_id: params[:participants][:community_members][:community_id].to_s)
          if @p.update(editable: 0)
            @processDone = true
          end  
          
        end  
      end     
      
      unless @processDone 
      logger.debug "HERE 2"
      unless params[:participants][:howManyRecords].blank? 
       logger.debug "HERE 22"
        @how_many_hold = params[:participants][:howManyRecords].to_i
      
      if @how_many_hold > 0 && @how_many_hold < 26
       @how_many = @how_many_hold
       @processDone = true
      end 
      
      end
      end
      
      
    unless @processDone 
    logger.debug "HERE 3"
    end
      
    unless @processDone 
    logger.debug "HERE 4"
      if params[:participants][:mem_array]
        logger.debug "HERE 44"
        @size_mem_array = params[:participants][:mem_array].length
        logger.debug "@size_mem_array"
        logger.debug @size_mem_array
        @flashNotice = "New member Notification email has been sent to:"
        @current_row = 1
        params[:participants][:mem_array].each do |new_p|
          logger.debug "params['rbia'.concat(@current_row.to_s)]"
          logger.debug params['rbia'.concat(@current_row.to_s)]
          ## test for not null in Javascript as well
        unless new_p[:first_name].blank? || new_p[:last_name].blank? || new_p[:email_alternative].blank? || new_p[:alias].blank?

          @p = Participant.new(user_id: -9, community_id: params[:participants][:community_members][:community_id], 
               first_name: new_p[:first_name], last_name: new_p[:last_name], email_alternative: new_p[:email_alternative],
               alias: new_p[:alias], 
               is_active: params['rbia'.concat(@current_row.to_s)], 
               is_creator: params['rbic'.concat(@current_row.to_s)], 
               approved: 1, editable: 0) 
          if @p.save
          @current_row = @current_row + 1  
            ## SendMail...member_notification...send notification email
            @flashNotice.concat("...")
            @flashNotice.concat(new_p[:first_name])
            @flashNotice.concat(" ")
            @flashNotice.concat(new_p[:last_name])
            @flashNotice.concat(" at email address ")
            @flashNotice.concat(new_p[:email_alternative].to_s)
            @flashNotice.concat(".")
            flash.notice = @flashNotice
          end
        end  
        end
      end
    end
      
      is_user_signed_in("part/updateMebers")
          @participant = Participant.where("participant_id = :pid", {pid: getParticipantID})
          @members = Participant.where("community_id = :cid", {cid: getCommunityID})
      render :template => 'participants/community_members', 
          :locals => {participant: @participant, members: @members, editable: 3, num_rows: @how_many}
      
  end

  def community_members
  end


  def main_user_detail 
    
    is_user_signed_in("main user detail")
    @user = User.find(getUserID)
    @participant = Participant.find_by(user_id: getUserID)
    @contact_preference  = ContactPreference.where("participant_id = :pid", {pid: getParticipantID}).first
    if  @contact_preference.nil?
     @contact_preference  = ContactPreference.new
    end
    if getCommunityID
      @community = Community.find_by(user_id: getUserID)
      
    end
    
    if getUserType == 'lend' ||  getUserType == 'both'
    @lender_transfer = LenderTransfer.where("participant_id = :pid", {pid: getParticipantID}).first
    logger.debug "@lender_transfer.lender_transfer_id.nil?"
    logger.debug @lender_transfer.lender_transfer_id.nil? 
    if  @lender_transfer.lender_transfer_id.nil? 
     @lender_transfer  = LenderTransfer.new
    end
    logger.debug "GET LTI"
     logger.debug @lender_transfer
    @lender_item_condition = LenderItemCondition.where("participant_id = :pid", {pid: getParticipantID}).first
    
    if  @lender_item_condition.lender_item_condition_id.nil?
     @lender_item_condition  = LenderItemCondition.new
    end
    end
    logger.debug "GET LTI"
    logger.debug @lender_transfer
    render 'main_user_detail'
   
  end
  
  # GET /participants/1
  # GET /paricipants/1.json
  def show
   
    is_user_signed_in("part/show")
    
    if params[:name] 
      if params[:id]  ## item_id
        @participant = Participant.joins(:items).where("items.item_id = :iid", {iid: params[:id]})  
        render :partial => 'participants/nae_readonly', participant: @participant, item_type: 'borrow' 
      end  
    end  
      
    
    if params[:id] 
      @lookup = params[:id]  
    else 
      @lookup = id  
    end 
     @editable = 1   
     logger.debug "IN PART/SHOW"
     logger.debug @lookup
     if @lookup 
   
         case @lookup.to_s 
         when 'user_nae' 
           render 'user_nae'
         when 'community_members' 
            @participant = Participant.where("participant_id = :pid", {pid: getParticipantID})
            @members = Participant.where("community_id = :cid", {cid: getCommunityID})
           render 'participants/community_members', 
             :locals => {participant: @participant,  members: @members, editable: 0, num_rows: 0}
         when 'user_agreement' 
           @participant = Participant.find_by_participant_id( getParticipantID) 
           render :template => 'participants/user_agreement', participant: @participant, editable: @editable  
         when 'main_user_detail' 
           logger.debug "FINISHED ACTIVATION S?B HERE"
           session[:current_div] = "nae" 
           is_user_signed_in("main user detail")
            @user = User.find(getUserID)
            @participant = Participant.find_by(user_id: getUserID)
            logger.debug 
            @contact_preference  = ContactPreference.where("participant_id = :pid", {pid: getParticipantID}).first
            if  @contact_preference.nil?
            @contact_preference  = ContactPreference.new
            end
            if getCommunityID
            @community = Community.find_by(user_id: getUserID)
            end
    
    if getUserType == 'lend' ||  getUserType == 'both'
    @lender_transfer = LenderTransfer.where("participant_id = :pid", {pid: getParticipantID}).first
    
    if  @lender_transfer.nil? 
     @lender_transfer  = LenderTransfer.new
    end
  
    @lender_item_condition = LenderItemCondition.where("participant_id = :pid", {pid: getParticipantID}).first
    
    if  @lender_item_condition.nil?
     @lender_item_condition  = LenderItemCondition.new
    end
    end
           render 'participants/main_user_detail',
           :locals => {lender_transfer: @lender_transfer, lender_item_condition: @lender_item_condition, 
           participant: @participant, community: @community, contact_preference: @contact_preference, user: @user, editable: @editable}
         end  
    
     else 

          unless getParticipantID.nil?  
   		    @participant = Participant.find_by_participant_id( getParticipantID) 
          else 
   		    @participant = Participant.new 
          end 
   	
   	    render 'participants/user_nae', participant: @participant, editable: @editable  
	
     end 
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  
  def postUserAgreement
     
   if request.post? 
     
		    @cid_id = nil
				@participant = nil
				@saved = false

        if ((params[:participant][:instructions].to_i == 1) && (params[:participant][:goodwill].to_i == 1) && (params[:participant][:age_18_or_more].to_i == 1))  
           	
				@cid_id = get_random  ## from ApplicationHelper ties participant to community
	      @participant = Participant.new 
	      @participant.user_id = params[:participant][:user_id].to_s
				@participant.goodwill = params[:participant][:goodwill]
				@participant.age_18_or_more = params[:participant][:age_18_or_more]
				@participant.instructions =  params[:participant][:instructions]
				@participant.is_active = 1
				@participant.remote_ip = params[:participant][:remote_ip ]
		
		case params[:participant][:role_id].to_i 
			  
			  when 0  ## an individual
				@participant.is_creator = 0
				@participant.community_id = -9
			  when 1  ##  community creator
			  @participant.is_creator = 1
			  @participant.community_id = @cid_id
			  when 2   ## non-creator community member
			  @participant.is_creator = 2
			  @participant.community_id = @cid_id
		end	  

					 if @participant.save
					  
					  @user = User.find_by(user_id: params[:participant][:user_id].to_s)
					  session[:username] = @user.username
					  is_user_signed_in('postUserAgreement')
					  
					  session[:acceptID] = true
					  session[:partID] = false
					  session[:cpId] = false
					  session[:LICid] = false
					  session[:LITid] = false
					  flash[:notice] = "You have successfully completed your EchoMarket Registration."
					  @community = Community.where("user_id = :getUID", {getUID: getUserID}).first
            redirect_to :controller => 'participants', :action => 'main_user_detail'
					 else
			  
					  sign_out
					  reset_session
					  flash[:notice] = "EchoMarket failed to Save/Update your Agreement"
					  session[:user_action] = "login"  ## used to be userLogin
					  render 'users/app_options'
			      end
	
		
		else
		  ## params not found
		   flash[:notice] = "EchoMarket failed to Save/Update your Agreement  because of missing imformation"
		  render 'users/app_options'
		   
		end  ## close present values
     end ## close request  
  end  ## close def


  def user_nae
            logger.debug "ON LOGIN IS THIS CALLED?"
            @participant = Participant.find_by_participant_id( getParticipantID) 
            if @participant 
            @editable = 0  
            @cd = ContactDescribe.find_by(contact_describe_id:  @participant.contact_describe_id ).borrower_or_lender_text 
            @a_primary = @participant.addresses.find_by(address_type:'primary')  
            @cpr = Country.find_by(country_id: @a_primary.country_id).country_name 
           
            @a_alternative = @participant.addresses.find_by(address_type:'alternative')  
            @calt = Country.find_by(country_id: @a_alternative.country_id).country_name  unless @a_alternative.nil? 

            @spr = UsState.find_by(us_state_id: @a_primary.us_state_id).state_name 
            @salt = UsState.find_by(us_state_id: @a_alternative.us_state_id).state_name   unless @a_alternative.nil? 
            end
  end          

  def community_members
  #   is_user_signed_in("part/community_members")
  # ## @user = User.find(getUserID)
  #   @participant = Participant.find_by(user_id: getUserID)
  # ## render 'community_members', :locals => {:participant => @participant}
  end

  # POST /participants
  # POST /participants.json
  def create
     
     @participant = Participant.new(:remote_ip => params[:participant][:remote_ip],
	                                :user_id => params[:participant][:user_id], 
									:contact_describe_id=> params[:participant][:contact_describe_id], 
									:instructions => params[:participant][:instructions], 
									:goodwill => params[:participant][:goodwill], 
									:age_18_or_more => params[:participant][:age_18_or_more],
									:created_at => Time.current, 
									:updated_at => Time.current,
									:date_deleted => Time.current)       
									
									

    respond_to do |format|
      if @participant.save
        format.html { redirect_to @participant, notice: 'Participant was successfully created.' }
        format.json { render :show, status: :created, location: @participant }
      else
        format.html { render :new }
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_condition
      @pid = nil
      @iid = nil
      @lit_id = nil
      
      if params[:participant][:lender_item_condition][:lender_item_condition_id]
        @lit_id = params[:participant][:lender_item_condition][:lender_item_condition_id]
      end  
      
      if params[:participant][:lender_item_condition][:participant_id]
        @pid = params[:participant][:lender_item_condition][:participant_id]
      else
        @pid = getParticipantID
      end  
      
      if params[:participant][:lender_item_condition][:item_id]
        @iid = params[:participant][:lender_item_condition][:item_id]
      else
        @iid = session[:item_id]
      end  
      
      result_success = false
      @lender_item_condition = nil
      
          if @lit_id.blank?
    		  ##  Create a new record
    		  @lender_item_condition = LenderItemCondition.new
    		  
    		  @lender_item_condition.participant_id = @pid
    		  @lender_item_condition.item_id = @iid
    		  @lender_item_condition.for_free = params[:participant][:lender_item_condition][:for_free]
          @lender_item_condition.available_for_purchase = params[:participant][:lender_item_condition][:available_for_purchase]   
          @lender_item_condition.available_for_purchase_amount  = params[:participant][:lender_item_condition][:available_for_purchase_amount]   
          @lender_item_condition.small_fee = params[:participant][:lender_item_condition][:small_fee]   
          @lender_item_condition.small_fee_amount = params[:participant][:lender_item_condition][:small_fee_amount]   
          @lender_item_condition.security_deposit = params[:participant][:lender_item_condition][:security_deposit]
          @lender_item_condition.security_deposit_amount = params[:participant][:lender_item_condition][:security_deposit_amount]   
          @lender_item_condition.available_for_donation = params[:participant][:lender_item_condition][:available_for_donation]
          @lender_item_condition.donate_anonymous = params[:participant][:lender_item_condition][:donate_anonymous]
          @lender_item_condition.trade = params[:participant][:lender_item_condition][:trade]
          @lender_item_condition.trade_item = params[:participant][:lender_item_condition][:trade_item]
          @lender_item_condition.agreed_number_of_days = params[:participant][:lender_item_condition][:agreed_number_of_days]   
          @lender_item_condition.agreed_number_of_hours = params[:participant][:lender_item_condition][:agreed_number_of_hours]   
          @lender_item_condition.indefinite_duration = params[:participant][:lender_item_condition][:indefinite_duration]
          @lender_item_condition.present_during_borrowing_period = params[:participant][:lender_item_condition][:present_during_borrowing_period]   
          @lender_item_condition.entire_period = params[:participant][:lender_item_condition][:entire_period]   
          @lender_item_condition.partial_period = params[:participant][:lender_item_condition][:partial_period]   
          @lender_item_condition.provide_proper_use_training = params[:participant][:lender_item_condition][:provide_proper_use_training]   
          @lender_item_condition.specific_conditions = params[:participant][:lender_item_condition][:specific_conditions]   
          @lender_item_condition.remote_ip = params[:participant][:lender_item_condition][:remote_ip]   
          @lender_item_condition.comment = params[:participant][:lender_item_condition][:comment]
          @lender_item_condition.save
    		  result_success = true
          else
    		
    		  @lender_item_condition = LenderItemCondition.find(@lit_id)
				  result_success = @lender_item_condition.update(lender_item_condition_params)
          end
				
          if result_success
            session[:LICid] = true
            @lender_item_condition
          else    
            session[:LICid] = true
            @lender_item_condition
          end            
		
  end

  def update_transfer
    
    logger.debug "IN UPDATE TRANSFER"
      @pid = nil
      @iid = nil
      @lit_id = nil
      
      if params[:participant][:lender_transfer][:lender_transfer_id]
        @lit_id = params[:participant][:lender_transfer][:lender_transfer_id]
      end  
      logger.debug "WHAT IS ID"
      logger.debug @lit_id
      
      
      if params[:participant][:lender_transfer][:participant_id]
        @pid = params[:participant][:lender_transfer][:participant_id]
      else
        @pid = getParticipantID
      end  
      
      if params[:participant][:lender_transfer][:item_id]
        @iid = params[:participant][:lender_transfer][:item_id]
      else
        @iid = session[:item_id]
      end  
      
      result_success = false
      @lender_transfer = nil
      
          if @lit_id.blank?
    		  ##  Create a new record
    		  @lender_transfer = LenderTransfer.new
    		  
    		  @lender_transfer.participant_id = @pid
    		  @lender_transfer.item_id = @iid
    		  @lender_transfer.borrower_comes_to_which_address = params[:participant][:lender_transfer][:borrower_comes_to_which_address]
          @lender_transfer.meetBorrowerAtAgreed = params[:participant][:lender_transfer][:meetBorrowerAtAgreed]   
          @lender_transfer.meetBorrowerAtAgreedLenderChoice  = params[:participant][:lender_transfer][:meetBorrowerAtAgreedLenderChoice]   
          @lender_transfer.meetBorrowerAtAgreedBorrowerChoice = params[:participant][:lender_transfer][:meetBorrowerAtAgreedBorrowerChoice]   
          @lender_transfer.meetBorrowerAtAgreedMutual = params[:participant][:lender_transfer][:meetBorrowerAtAgreedMutual]   
          @lender_transfer.will_deliver_to_borrower = params[:participant][:lender_transfer][:will_deliver_to_borrower]   
          @lender_transfer.thirdPartyPresence = params[:participant][:lender_transfer][:thirdPartyPresence]   
          @lender_transfer.thirdPartyPresenceLenderChoice = params[:participant][:lender_transfer][:thirdPartyPresenceLenderChoice]   
          @lender_transfer.thirdPartyPresenceBorrowerChoice  = params[:participant][:lender_transfer][:thirdPartyPresenceBorrowerChoice]   
          @lender_transfer.thirdPartyPresenceMutual = params[:participant][:lender_transfer][:thirdPartyPresenceMutual]   
          @lender_transfer.borrower_returns_to_which_address = params[:participant][:lender_transfer][:borrower_returns_to_which_address]   
          @lender_transfer.willPickUpPreferredLocation = params[:participant][:lender_transfer][:willPickUpPreferredLocation]   
          @lender_transfer.remote_ip = params[:participant][:lender_transfer][:remote_ip]   
          @lender_transfer.comment = params[:participant][:lender_transfer][:comment]
          @lender_transfer.save
    		  result_success = true
          else
    		
    		  @lender_transfer = LenderTransfer.find(@lit_id)
				  result_success = @lender_transfer.update(lender_transfer_params)
          end
				  
          if result_success
            session[:LITid] = true
            
            @lender_transfer
          else    
            session[:LITid] = true
            @lender_transfer
          end            
	
  end

  def update_participant
  	 logger.debug "IN UPDATE PART"
      pid = params[:participant][:participant][:participant_id]
      result_success = false
      @aid = nil
      uid = params[:participant][:participant][:user_id]
            
    		@participant = Participant.find(pid)
				unless @participant.nil?
				result_success = @participant.update(participant_params)
				else
				logger.debug "Manage could not find participant"
				end 

				 if result_success
				  ## SAVE OR UPDATE PRIMARY ADDRESS	
				  @aid = params[:participant][:participant][:primary_address][:address_id]
				  
				  if @aid.blank?
				  
				  @a = @participant.addresses.create(address_line_1: params[:participant][:participant][:primary_address][:address_line_1], 
				              address_line_2: params[:participant][:participant][:primary_address][:address_line_2], 
				              city: params[:participant][:participant][:primary_address][:city], 
				              us_state_id: params[:participant][:participant][:primary_address][:us_state_id],
				              country_id: params[:participant][:participant][:primary_address][:country_id],
				              region: params[:participant][:participant][:primary_address][:region], 
				              province: params[:participant][:participant][:primary_address][:province], 
				              postal_code: params[:participant][:participant][:primary_address][:postal_code],
				              address_type:params[:participant][:participant][:primary_address][:address_type] )
				   
				   
				   else 
				   	 
				   @a = Address.find_by_address_id(@aid.to_i)
					 @a.update(primary_address_params)
				 
				       
				  end
				  
        			
        		  ## SAVE OR UPDATE ALTERNATIVE ADDRESS
        		  @wantsAlternativeAddress = params[:participant][:participant][:question_alt_address]
        		  unless @wantsAlternativeAddress.to_i == 0 
          		  @aid = params[:participant][:participant][:alternative_address][:address_id]
  				      
  		          if @aid.blank?

  				        @a = @participant.addresses.create(address_line_1: params[:participant][:participant][:alternative_address][:address_line_1].to_s, 
  				              address_line_2: params[:participant][:participant][:alternative_address][:address_line_2], 
  				              city: params[:participant][:participant][:alternative_address][:city], 
  				              us_state_id: params[:participant][:participant][:alternative_address][:us_state_id],
  				              country_id: params[:participant][:participant][:alternative_address][:country_id],
  				              region: params[:participant][:participant][:alternative_address][:region], 
  				              province: params[:participant][:participant][:alternative_address][:province], 
  				              postal_code: params[:participant][:participant][:alternative_address][:postal_code],
  				              address_type: params[:participant][:participant][:alternative_address][:address_type] )
  				   
  				   
  				      else 
  				   	
  				         @a = Address.find_by_address_id(@aid.to_i)
  					       @a.update(alternative_address_params)
  				 
  				       
  				      end 
				      
				      end
				  
          
		       end
		        
		        if result_success 
		        	@participant
		        else
		          @participant
		        end	
				  
		
      
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
  end

  private

    def set_participant

	if params[:participate_id]
      @participant = Participant.find(params[:participate_id])
	end  

    end

    
    def participant_params

      params.require(:participant).require(:participant).permit(:first_name, :mi, 
          :last_name,  :user_id, :community_id, :contact_describe_id, :display_name,
    			:organization_name, :display_organization, :other_describe_yourself, 
    			:display_address, :home_phone, :cell_phone, :alternative_phone, 
    			:email_alternative, :question_alt_email, :question_alt_address, 
    			:display_home_phone, :display_cell_phone, :display_alternative_phone, 
    			:display_alternative_address)

    end
    
 
     def primary_address_params
       params.require(:participant).require(:participant).require(:primary_address).permit(:address_line_1, :address_line_2, :postal_code, :city, :province, :us_state_id, :region, :country_id, :address_type)
     end
    
    def alternative_address_params
      params.require(:participant).require(:participant).require(:alternative_address).permit(:address_line_1, :address_line_2, :postal_code, :city, :province, :us_state_id, :region, :country_id, :address_type)
    end
	
    def lender_item_condition_params
      params.require(:participant).require(:lender_item_condition).permit(:item_id, :participant_id, :for_free, :available_for_purchase, 
      :available_for_purchase_amount, :small_fee, :small_fee_amount, :available_for_donation, :donate_anonymous, 
      :trade, :trade_item, :agreed_number_of_days, :agreed_number_of_hours, :indefinite_duration, :present_during_borrowing_period, 
      :entire_period, :partial_period, :provide_proper_use_training, :specific_conditions, :security_deposit_amount, :security_deposit, 
      :remote_ip, :comment)
    end
    
     def lender_transfer_params
      params.require(:participant).require(:lender_transfer).permit(:item_id, :participant_id, 
      :borrower_comes_to_which_address,  :meetBorrowerAtAgreed, :meetBorrowerAtAgreedLenderChoice, 
      :meetBorrowerAtAgreedBorrowerChoice, :meetBorrowerAtAgreedMutual, :will_deliver_to_borrower, 
      :thirdPartyPresence, :thirdPartyPresenceLenderChoice, :thirdPartyPresenceBorrowerChoice, 
      :thirdPartyPresenceMutual, :borrower_returns_to_which_address, :willPickUpPreferredLocation, 
      :remote_ip, :comment)
    end

  
end
