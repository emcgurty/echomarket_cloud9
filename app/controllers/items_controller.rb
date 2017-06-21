class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
    ## Use of @@ needs to be rewritten
    @@item_result = nil
    @@cp_result = nil
    @@transfer_result = nil
    @@condition_result =  nil
    
  def index
  end

  def show
  end  # close def

  def search_results
      
    @item = Item.find_by(item_id: params[:id])
    @participant = Participant.find_by(participant_id: @item.participant_id)
    @cd = ContactDescribe.find_by(contact_describe_id:  @participant.contact_describe_id ).borrower_or_lender_text 
    @a_primary = @participant.addresses.find_by(address_type:'primary')  
    @cpr = Country.find_by(country_id: @a_primary.country_id).country_name 
           
    @a_alternative = @participant.addresses.find_by(address_type:'alternative')  
    @calt = Country.find_by(country_id: @a_alternative.country_id).country_name  unless @a_alternative.nil? 

    @spr = UsState.find_by(us_state_id: @a_primary.us_state_id).state_name 
    @salt = UsState.find_by(us_state_id: @a_alternative.us_state_id).state_name   unless @a_alternative.nil? 
    @contact_preference = ContactPreference.find_by(participant_id: @item.participant_id, item_id: @item.item_id)
    if @item.item_type == 'lend'
    @lender_transfer = LenderTransfer.find_by(participant_id: @item.participant_id, item_id: @item.item_id)
    @lender_item_condition = LenderItemCondition.find_by(participant_id: @item.participant_id, item_id: @item.item_id)
    end
    render :template => "items/main_item_readonly"
 
  end        
  
  
  def new_item
    is_user_signed_in("new_item") 
    session[:complete] = false
    @completedRecordMessage = nil
    @counter = 0
    logger.debug "TESTING CALL FROM BH"
    logger.debug params[:item_id]
    logger.debug params[:id]
    
    unless params[:item_id].blank?

        @item = Item.find_by(item_id: params[:item_id].to_i)  
            @strMsg = "Your item, "
            @strMsg.concat(@item.item_description)
            @strMsg.concat(", exists.")
            @completedRecordMessage = @strMsg
            @counter = @counter + 1
            logger.debug "Item 1"
        
    else
        
        if @@item_result
            @item = @item_result
            @strMsg = "Your new item, "
            @strMsg.concat(@item.item_description)
            @strMsg.concat(", has been saved.")
            @completedRecordMessage = @strMsg
            @counter = @counter + 1
            logger.debug "Item 2"
        else    
            @item = Item.new
            @item.participant_id =  params[:id]
            @item.item_type = getUserType
            @item_image = ItemImage.new
            logger.debug "Item 3"
        end     
    end    
   
    begin
        @new_item_id = @item.item_id
    rescue
    end
    
    @participant = Participant.find_by(participant_id: params[:id])

    unless @@cp_result.nil?
        @contact_preference = @@cp_result
        @strMsg = "Your item Contact Preferences have been saved."
        @completedRecordMessage.concat(@strMsg)
        @counter = @counter + 1
    else    
        @contact_preference = ContactPreference.find_by(participant_id: getParticipantID, item_id: @new_item_id )
        if @contact_preference.nil?
          @contact_preference = ContactPreference.find_by(participant_id: getParticipantID )
        else
            @strMsg = "Your item Contact Preferences exist."
            @completedRecordMessage.concat(@strMsg)
            @counter = @counter + 1
        end
    end    
        logger.debug "getUserType here"
        logger.debug getUserType
        if getUserType == 'lend' || getUserType == 'both'
            
        
            unless @@transfer_result.nil?
                @lender_transfer = @@transfer_result
                @strMsg = "Your item Lender Transfer Preferences have been saved."
                @completedRecordMessage.concat(@strMsg)
                @counter = @counter + 1
            else
                @lender_transfer = LenderTransfer.find_by(participant_id: getParticipantID, item_id: @new_item_id) 
                    if @lender_transfer.nil?
                    @lender_transfer = LenderTransfer.find_by(participant_id: getParticipantID) 
                    else
                    @strMsg = "Your item Lender Transfer Preferences exist."
                    @completedRecordMessage.concat(@strMsg)    
                    @counter = @counter + 1
                    end   
            end        
            
            unless @@condition_result.nil?
                @lender_item_condition = @@condition_result
                    @strMsg = " Your item Lender Conditions have been saved."
                    @completedRecordMessage.concat(@strMsg)    
                    @counter = @counter + 1
            else
                @lender_item_condition = LenderItemCondition.find_by(participant_id: getParticipantID, item_id: @new_item_id) 
                    if @lender_item_condition.nil?
                    @lender_item_condition = LenderItemCondition.find_by(participant_id: getParticipantID)     
                    else
                    @strMsg = "Your item Lender Conditions exist."
                    @completedRecordMessage.concat(@strMsg)    
                    @counter = @counter + 1
                    end    
            end    
        end    

        
        if @completedRecordMessage.nil? 
            if getUserType == 'lend' || getUserType == 'both'
                flash[:notice] = "In offering a new Item to Lend, you must provide Item detail, and save or update your Contact Preference, Lender Transfer and Conditions Information."
            else
                flash[:notice] = "In seeking a new Item to Borrow, you must provide Item detail, and save or update Contact Preference Information."        
            end
        else     
        if @counter == 4
           session[:complete] = true
           flash[:notice] = "You have completed your new item record.  You may continue to makes edits. Or you may choose to create another new item."
           
        else
          flash[:notice] = @completedRecordMessage    
        end

end
    
 
  end       
  
  
  # GET /items
  # GET /items.json
  def borrowing_history
       is_user_signed_in("borrowing_history")      
       @h = params[:id].split(',').to_a 
    
       @b =  false
       @l =  false
       @c =  false
       @i =  false
       @both =  false
    
       @b =  @h.include? 'borrow' 
       @l =  @h.include? 'lend' 
       @c =  @h.include? 'community' 
       @i =  @h.include? 'individual' 
       @both =  @h.include? 'both' 
       @all =  @h.include? 'all' 
       ## WHERE returns ActiveRecord which must be output with .each    
    if @all      
     if getCommunityID    
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "'" )  
     else
         @item = Item.where(participant_id: @h.at(2))
     end
    else  
     unless @both
     if @b && @i 
  		 @item = Item.where(participant_id: @h.at(2), item_type:  'borrow')
     elsif @b && @c 
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h.at(2).to_s + "' and items.item_type = 'borrow'")  
     end 
  
     if @l && @i 

  		 @item = Item.where(participant_id: @h.at(2).to_s, item_type: 'lend') 
     elsif @l && @c 

       @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "' and items.item_type = 'lend'")  
     end 
     
     else
         if @i 
  		 @item = Item.where(participant_id: @h.at(2).to_s) 
         elsif @c 
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "'" )  
         end 
    end     
    end 
     render 'borrowing_history', :locals => {:item => @item}
  end  
  
  
  # GET /items/new
  def new
  end

  
  def edit
  end

  # POST /items
  # POST /items.json
  def create
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update

     @pid =  params[:items][:item][:participant_id]
     @item_id =  params[:items][:item][:item_id]
     @hold_item = nil
     @hold_cp = nil
     @hold_transfer = nil
     @hold_condition = nil
     
     item_changed = -1
     cp_changed = -1
     transfer_changed = -1
     condition_changed = -1
     
     item_changed = params[:items][:item][:item_changed].to_i
     
     unless @item_id.blank?
     if params[:items][:contact_preference]
     cp_changed = params[:items][:contact_preference][:preference_changed].to_i unless params[:items][:contact_preference][:preference_changed].blank?
     end
     if params[:items][:lender_transfer]
     transfer_changed = params[:items][:lender_transfer][:transfer_changed].to_i unless params[:items][:lender_transfer][:transfer_changed].blank?
     end
 
     if params[:items][:lender_transfer]
     condition_changed = params[:items][:lender_item_condition][:condition_changed].to_i unless params[:items][:lender_item_condition][:condition_changed].blank?
     end
     end
     
     
     if item_changed == 1 
        @hold_item = update_item
        ##logger.debug "IS HOLD ITEM NIL"
        ##logger.debug @hold_item.to_yaml
        unless @hold_item.nil?
          item_changed = 0
        end
     end

    ### prevent these unless Item.item_id has been defined
     unless @item_id.nil?
     
     if cp_changed == 1 
        @hold_cp = update_cp
        unless @hold_cp.nil?
          cp_changed = 0
        end
     end

     if transfer_changed == 1 
        @hold_transfer = update_transfer
        unless @hold_transfer.nil?
          transfer_changed = 0
        end
     end
     
     if condition_changed == 1 
        @hold_condition = update_condition
        unless @hold_condition.nil?
          condition_changed = 0
        end
     end
     
 end
          
    ## This should also permit erb/model error reporting
    
    @item_result = (item_changed == 1 ? @hold_item : nil)
    @cp_result = (cp_changed == 1 ? @hold_cp : nil)
    @transfer_result = (transfer_changed == 1 ? @hold_transfer : nil)
    @condition_result =  (condition_changed == 1 ? @hold_condition : nil)
    unless  @hold_item.blank?
        @ci = @hold_item.item_id 
    else
        @ci = @item_id   
    end    
    redirect_to  :controller=> 'items', :action => 'new_item', :id => @pid, :item_id  => @ci 
    
    @@item_result = (item_changed == 1 ? @hold_item : nil)
    @@cp_result = (cp_changed == 1 ? @hold_cp : nil)
    @@transfer_result = (transfer_changed == 1 ? @hold_transfer : nil)
    @@condition_result =  (condition_changed == 1 ? @hold_condition : nil)

  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
 
  end

  private
  
    def update_item
     @pid =  params[:items][:item][:participant_id]
     @iid = params[:items][:item][:item_images][:item_image_id]
     @upi =  params[:items][:item][:item_images][:uploaded_picture]
     @iic = params[:items][:item][:item_images][:item_image_caption].to_s
     @item_id = params[:items][:item][:item_id]
     @ut = params[:items][:item_type]
     
     @current_item = nil
     @im = nil
     params = nil
     @itemID = nil
     @readonly = false
     @ut = nil
     
     
     @part = Participant.where("participant_id = :pid", {pid: @pid}).first
     
     if @item_id.blank?
       
       @current_item = @part.items.create!(new_item_params)
       @current_item = @current_item.item_id
  
       
       
     else
       @pit = @part.items.find_by(item_id: @item_id) 
       @current_item = @pit.update!(update_item_params)
       @current_item = @item_id
  
     end 
     
      
      @current_item = Item.find_by(item_id: @current_item)
  
      logger.debug @current_item.item_id
      
      if @current_item.item_id 
       
         session[:item_id] = @current_item.item_id
         @itemID = @current_item.item_id
         @ut = @current_item.item_type
         
      

    
     unless @iid.blank?
       @im = @current_item.item_images.update(item_image_params)

     else
       
       @im = ItemImage.new
       @im.name_prefix = @itemID
       @im.item_type = @ut
       @im.item_image_caption = @iic 
       @im.uploaded_picture =  @upi
       @im.item_id = @itemID
       @im.save
     end
    
    else
      logger.debug "TODO Write for no param ID"
    end 
    
     @current_item
 
    end    
    
 def update_cp

 
     @pid =  params[:items][:item][:participant_id]
     @item_id = params[:items][:contact_preference][:item_id]
     @current_item = nil
     
    if @item_id.nil?
 
       @part = Participant.where("participant_id = :pid", {pid: @pid}).first        
       @current_item = @part.contact_preferences.create!(contact_preference_params)

    else
       @cp = ContactPreference.where("participant_id = :pid and item_id = :iid", {pid: @pid, iid: @item_id }).first
       if @cp
        @current_item = @cp.update!(contact_preference_params)
       else 
        @part = Participant.where("participant_id = :pid", {pid: @pid}).first   
        @current_item = @part.contact_preferences.create!(contact_preference_params)
       end
    end 
     
     @current_item

 end    
    
 def update_transfer

     @pid =  params[:items][:item][:participant_id]
     @item_id = params[:items][:lender_transfer][:item_id]
     @current_item = nil
     
     if @item_id.nil?
       @part = Participant.where("participant_id = :pid", {pid: @pid}).first          
       @current_item = @part.lender_transfers.create!(lender_transfer_params)

     else
       @cp = LenderTransfer.where("participant_id = :pid and item_id = :iid", {pid: @pid, iid: @item_id }).first
       if @cp
            @current_item = @cp.update!(lender_transfer_params)
       else       
            @part = Participant.where("participant_id = :pid", {pid: @pid}).first   
            @current_item = @part.lender_transfers.create!(lender_transfer_params)
        end       

     end 
     
     @current_item

 end    
 
    def update_condition

     @pid =  params[:items][:item][:participant_id]
     @item_id = params[:items][:lender_item_condition][:item_id]
     @current_item = nil
     
     if @item_id.nil?
       @part = Participant.where("participant_id = :pid", {pid: @pid}).first             
       @current_item = @part.lender_item_condition.create!(lender_item_condition_params)

     else
       @cp = LenderItemCondition.where("participant_id = :pid and item_id = :iid", {pid: @pid, iid: @item_id }).first
       if @cp
            @current_item = @cp.update!(lender_item_condition_params)
       else
            @part = Participant.where("participant_id = :pid", {pid: @pid}).first   
            @current_item = @part.lender_item_conditions.create!(lender_item_condition_params)           
       end

     end 
     
     @current_item

    end    
 
    def set_item
      #unless params[:item][:item_id].nil?
      #@item = Item.find(params[:item][:item_id])
    #end
    end

    
    def item_params
    #   params.require(:item).permit(:item_id,  :participant_id,  :category_id, :other_item_category, :item_model, 
    #                   :item_description, :item_condition_id, :item_count, 
    #                   :comment, :created_at, :updated_at, :date_deleted, 
    #                   :approved, :notify, :item_type, :remote_ip)
    params.require(:item).permit(:item, :contact_preference, :lender_transfer, :lender_item_condition)                      
    end
    
    def new_item_params
        
      ## This needs to be rewritten becuase to_hash to be deprecated    
      _item_id = params[:items][:item][:item_id],
      _participant_id = params[:items][:item][:participant_id],
      _category_id = params[:items][:item][:category_id], 
      _other_item_category = params[:items][:item][:other_item_category], 
      _item_model = params[:items][:item][:item_model], 
      _item_description = params[:items][:item][:item_description], 
      _item_condition_id = params[:items][:item][:item_condition_id], 
      _item_count =  params[:items][:item][:item_count],
      _comment = params[:items][:item][:comment],
      _approved = 1, 
      _notify = params[:items][:item][:notify], 
      _item_type = params[:item][:item_type], 
      _remote_ip = params[:items][:item][:remote_ip]
              
      params = ActionController::Parameters.new(
           {
              item_id: _item_id,
              participant_id: _participant_id,
              category_id: _category_id, 
              other_item_category: _other_item_category, 
              item_model: _item_model, 
              item_description: _item_description, 
              item_condition_id: _item_condition_id, 
              item_count: _item_count,
              comment: _comment,
              approved: 1, 
              notify: _notify, 
              item_type: _item_type, 
              remote_ip: _remote_ip, 
              created_at: Time.current,
              updated_at: Time.current,
              date_deleted: Time.current  
    
})
        
       # params.require(:items).permit(:item)
       # params.permit(:items, :item    , :item_id,  :participant_id,  )
      params.to_hash
    end
    
  def contact_preference_params
      ## Don't include foreign keys
      params.require(:items).require(:contact_preference).permit(:item_id, :user_id, :use_which_contact_address,
                     :contact_by_chat, :contact_by_email, :contact_by_home_phone, :contact_by_cell_phone,  
                     :contact_by_alternative_phone, :contact_by_Facebook, :contact_by_Twitter,  :contact_by_Instagram, 
                     :contact_by_LinkedIn,  :contact_by_other_social_media,  :contact_by_other_social_media_access)
                    
  end
    
     def lender_transfer_params
      params.require(:items).require(:lender_transfer).permit(:item_id, :participant_id, 
      :borrower_comes_to_which_address,  :meetBorrowerAtAgreed, :meetBorrowerAtAgreedLenderChoice, 
      :meetBorrowerAtAgreedBorrowerChoice, :meetBorrowerAtAgreedMutual, :will_deliver_to_borrower, 
      :thirdPartyPresence, :thirdPartyPresenceLenderChoice, :thirdPartyPresenceBorrowerChoice, 
      :thirdPartyPresenceMutual, :borrower_returns_to_which_address, :willPickUpPreferredLocation, 
      :remote_ip, :comment)
     end
    
    def lender_item_condition_params
      params.require(:items).require(:lender_item_condition).permit(:item_id, :participant_id, :for_free, :available_for_purchase, 
      :available_for_purchase_amount, :small_fee, :small_fee_amount, :available_for_donation, :donate_anonymous, 
      :trade, :trade_item, :agreed_number_of_days, :agreed_number_of_hours, :indefinite_duration, :present_during_borrowing_period, 
      :entire_period, :partial_period, :provide_proper_use_training, :specific_conditions, :security_deposit_amount, :security_deposit, 
      :remote_ip, :comment)
    end
    
    def item_image_params
        
        params.require(:items).require(:item).require(:item_images).permit(:item_type, :item_image_caption, :uploaded_picture, :name_prefix)
    end        
    
    def update_item_params
        
        params.require(:items).require(:item).permit(:item_id, :category_id,
                :other_item_category, :item_model, :item_description, :item_condition_id , 
                :item_count , :comment,  :approved, :notify , :item_type) 
      

    end
            
end

   