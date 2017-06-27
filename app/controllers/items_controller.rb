class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

    def shout
        is_user_signed_in("shout")
        case params[:id].to_s
        when "lender_yes"
            ## Lender shouts to borrowers
            @l_item = Item.find_by(item_id: session[:item_id], participant_id: getParticipantID)
            unless @l_item.nil? 
            @l_cat = @l_item.category_id
            @l_item_type = @l_item.item_type
            
            @item = Item.where(item_id: session[:item_id], notify: 1, category_id: @l_cat, item_type: @l_item_type)
            unless @item.nil?
            @borrowerAlias = getUserAlias
            ## CAN NOT PERFORM EACH IN USERMAILER
            @item.each do |itm|
            @result = UserMailer.shout_to_lender(itm, @borrowerAlias).deliver_now	
            end
            end
            else
                flash.notice = "No matching Lenders were found"
            end
        when "lender_no"    
            @item = Item.find(session[:item_id])
            @item.update(notify: -9)
        when "borrower_yes"
            ## borrower shouts to lenders
            @b_item = Item.find_by(item_id: session[:item_id], participant_id: getParticipantID)
            unless @b_item.nil?
            @b_cat = @b_item.category_id
            @b_item_type = @b_item.item_type
            @item = Item.where(item_id: session[:item_id], notify: 1, category_id: @b_cat, item_type: @b_item_type)
            @lenderAlias = getUserAlias
            ## CAN NOT PERFORM EACH IN USERMAILER
            unless @item.nil?
            @item.each do |itm|
            @result = UserMailer.shout_to_lender(itm, @lenderAlias).deliver_now	
            end
            end
            else
            flash.notice = "No matching Borrowers were found"
            end
        when "borrower_no"                
            @item = Item.find(session[:item_id])
            @item.update(notify: -9)
        end    
        
    flash.notice = "Your Item Has been successfully Shouted"
    redirect_to :controller => 'participants', :action => 'main_user_detail'
    end


  def index
  end

  def show
      logger.debug "RENDER ITEMS HERE"
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
    logger.debug "IN NEW_ITEM" 
    is_user_signed_in("new_item") 
    session[:complete] = false
    flash.notice =  nil unless params[:item_id]
    @cp = false
    @lc = false
    @lt = false
    @item = nil
    @contact_preference = nil
    @lender_transfer = nil
    @lender_item_condition = nil

   logger.debug "params[:id] && (params[:item_id].nil? || params[:item_id].blank?)"
   logger.debug params[:id] && (params[:item_id].nil? || params[:item_id].blank?)
    if params[:id] && (params[:item_id].nil? || params[:item_id].blank?)
            @item = Item.new
            @item.participant_id = params[:id]
            @item.item_type = getUserType
            @item_image = ItemImage.new
    else
     session[:item_id] = params[:item_id]
     @item = Item.find_by(item_id: params[:item_id])
     @contact_preference = ContactPreference.find_by(item_id: params[:item_id], participant_id: params[:id])
     if @contact_preference.nil? 
     @contact_preference = ContactPreference.find_by(item_id: -1, participant_id: params[:id])
     end     
     
     
     @lender_transfer = LenderTransfer.find_by(item_id: params[:item_id], participant_id: params[:id])
     if @lender_transfer.nil?
     @lender_transfer = LenderTransfer.find_by(item_id: '', participant_id: params[:id])
     end
     
     @lender_item_condition = LenderItemCondition.find_by(item_id: params[:item_id], participant_id: params[:id])
     if @lender_item_condition.nil?
     @lender_item_condition = LenderItemCondition.find_by(item_id: '', participant_id: params[:id])
     end
     
     unless @contact_preference.nil? 
     @cp = (@contact_preference.item_id.to_i == -1 ? false : true )
     end
     
     unless @lender_transfer.nil? 
     @lt = (@lender_transfer.item_id.to_s == '' ? false : true)
     end
     
     unless @lender_item_condition.nil? 
     @lc = (@lender_item_condition.item_id.to_s == '' ? false : true)
     end
     
    end
      
     if flash.notice.nil? 
            if @item
               if @item.item_type
                  @ut =  @item.item_type
               end
            else
                  @ut =  getUserType
            end    
            if getUserType == 'lend' || getUserType == 'both'
                flash[:notice] = "In offering a new Item to Lend, you must provide Item detail, and save or update your Contact Preference, Lender Transfer and Conditions Information."
            else
                flash[:notice] = "In seeking a new Item to Borrow, you must provide Item detail, and save or update Contact Preference Information."        
            end
     else
            if @item
     
             if @item.item_type
              if (@lt & @lc && (@item.item_type == 'lend' )) || (@cp && @item.item_type == 'borrow')
                session[:complete] = true
                @item.approved = 1
                @item.update(approved: 1)
                flash[:notice] = "You have completed your new item record.  You may continue to makes edits. Or you may choose to create another new item."
              else

              end
             end
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
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "'" ).order("item_type")
     else
         @item = Item.where(participant_id: @h.at(2)).order("item_type")
     end
    else  
     unless @both
     if @b && @i 
  		 @item = Item.where(participant_id: @h.at(2), item_type:  'borrow').order("item_type")
     elsif @b && @c 
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h.at(2).to_s + "' and items.item_type = 'borrow'").order("item_type")  
     end 
  
     if @l && @i 

  		 @item = Item.where(participant_id: @h.at(2).to_s, item_type: 'lend').order("item_type") 
     elsif @l && @c 

       @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "' and items.item_type = 'lend'").order("item_type").order("item_type")  
     end 
     
     else
         if @i 
  		 @item = Item.where(participant_id: @h.at(2).to_s).order("item_type") 
         elsif @c 
         @item = Item.joins(:participant).where("participants.community_id  = '"  + @h[2].to_s + "'" ).order("item_type")  
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
     @item = nil

     if params[:items][:item]
     if params[:items][:item][:item_changed]
     if params[:items][:item][:item_changed].to_i == 1
        @item = update_item
        @item_id = @item.item_id
     end
     end
     end

     unless @item_id.nil?
     
         if params[:items][:contact_preference]
         if params[:items][:contact_preference][:preference_changed]
         if params[:items][:contact_preference][:preference_changed].to_i == 1
            @contact_preference = update_cp
         end
         end
         end 
     
         if params[:items][:lender_transfer]
         if params[:items][:lender_transfer][:transfer_changed]
         if params[:items][:lender_transfer][:transfer_changed].to_i == 1
            @lender_transfer = update_transfer
         end
         end
         end
         
         if params[:items][:lender_item_condition]
         if params[:items][:lender_item_condition][:condition_changed]
         if params[:items][:lender_item_condition][:condition_changed].to_i == 1
            @lender_item_condition = update_condition
         end
         end   
         end
     
     end
     redirect_to  :controller=> 'items', :action => 'new_item', :id => @pid, :item_id => @item_id

    

  end


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
     @itemID = nil
     @readonly = false
     @ut = nil
     
     
     @part = Participant.where("participant_id = :pid", {pid: @pid}).first
     
     if @item_id.blank?
       
       @item = @part.items.create!(new_item_params)
       @current_item = @item.item_id
       @strMsg = "Your item, "
       @strMsg.concat(@item.item_description.to_s)
       @strMsg.concat(", has been saved.")
       flash.notice = @strMsg
       
       
       
     else
       @pit = @part.items.find_by(item_id: @item_id) 
       @item = @pit.update!(update_item_params)
       @item = Item.find_by(item_id: @item_id) 
       @current_item = @item.item_id
       @strMsg = "Your current item, "
       @strMsg.concat(@item.item_description.to_s)
       @strMsg.concat(", exists.")
       flash.notice = @strMsg

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
        flash.notice = "Your Contact Preference record has been updated."  
        @current_item = @cp.update!(contact_preference_params)
        
       else 
        @part = Participant.where("participant_id = :pid", {pid: @pid}).first   
        flash.notice = "Your Contact Preference record has been saved."
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
            flash.notice = "Your Lender Transfer record has been updated."
            @current_item = @cp.update!(lender_transfer_params)
            
       else       
            @part = Participant.where("participant_id = :pid", {pid: @pid}).first   
            flash.notice = "Your Lender Transfer record has been created."
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
            flash.notice = "Your Lender Item Condition record has been created."
            @current_item = @cp.update!(lender_item_condition_params)
       else
            @part = Participant.where("participant_id = :pid", {pid: @pid}).first 
            flash.notice = "Your Lender Item Condition record has been updated."
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
              approved: 0, 
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

   