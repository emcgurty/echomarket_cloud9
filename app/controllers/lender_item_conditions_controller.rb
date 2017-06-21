class LenderItemConditionsController < ApplicationController
  before_action :set_lender_item_condition, only: [:show, :edit, :update, :destroy]

  def index
    @lender_item_conditions = LenderItemCondition.all
  end

    
  def show
    if params[:name]
      logger.debug "params[:name].to_s"
      logger.debug params[:name].to_s
    end
    if     if params[:item_type]
      logger.debug "params[:item_type].to_s"
      logger.debug params[:item_type].to_s
    end
      logger.debug "params[:item_type].to_s"
      logger.debug params[:item_type].to_s
    end
    
    if params[:id]
        #@part = Participant.joins(:item).where("items.item_id =: itemId", {itemId: params[:id]})
        @lender_item_condition = LenderItemCondition.find_by(item_id: params[:id])        
        render :partial => 'lender_item_conditions/lender_conditions_readonly', 
          :locals => {lender_item_condition: @lender_item_condition, item_type: params[:item_type]}
    end  
    
  
    
  end 

  def lender_item_conditions
     is_user_signed_in('LIC')
     session_item_id = (session[:item_id] == '-1' ? nil : session[:item_id])  

  if session_item_id && getParticipantID 
      @lender_item_condition = LenderItemCondition.find_by(participant_id:getParticipantID, item_id: session[:item_id]) 
     elsif session_item_id && getParticipantID.nil? 
      @lender_item_condition = LenderItemCondition.find_by(item_id:session[:item_id]) 
     elsif session_item_id.nil? && getParticipantID 
      @lender_item_condition = LenderItemCondition.find_by(participant_id: getParticipantID) 
  end 
    
  end  

  def new
    @lender_item_condition = LenderItemCondition.new
  end

  
  def edit
  end

  def create
    @lender_item_condition = LenderItemCondition.new(lender_item_condition_params)

    respond_to do |format|
      if @lender_item_condition.save
        format.html { redirect_to @lender_item_condition, notice: 'Lender item condition was successfully created.' }
        format.json { render :show, status: :created, location: @lender_item_condition }
      else
        format.html { render :new }
        format.json { render json: @lender_item_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lender_item_conditions/1
  # PATCH/PUT /lender_item_conditions/1.json
  def update
      pid = nil
      iid = nil
      lit_id = nil
      
      if params[:lender_item_condition][:lender_item_condition_id]
        lit_id = params[:lender_item_condition][:lender_item_condition_id]
      end  
      
      if params[:lender_item_condition][:participant_id]
        pid = params[:lender_item_condition][:participant_id]
      else
        pid = getParticipantID
      end  
      
      if params[:lender_item_condition][:item_id]
        iid = params[:lender_item_condition][:item_id]
      else
        iid = session[:item_id]
      end  
      
      result_success = false
      @lit = nil
      
          if lit_id
    		  ##  Create a new record
    		  @lit = LenderItemCondition.new
    		  
    		  @lit.participant_id = pid
    		  @lit.item_id = iid
    		  @lit.for_free = params[:lender_item_condition][:for_free]
          @lit.available_for_purchase = params[:lender_item_condition][:available_for_purchase]   
          @lit.available_for_purchase_amount  = params[:lender_item_condition][:available_for_purchase_amount]   
          @lit.small_fee = params[:lender_item_condition][:small_fee]   
          @lit.small_fee_amount = params[:lender_item_condition][:small_fee_amount]   
          @lit.security_deposit = params[:lender_item_condition][:security_deposit]
          @lit.security_deposit_amount = params[:lender_item_condition][:security_deposit_amount]   
          @lit.available_for_donation = params[:lender_item_condition][:available_for_donation]
          @lit.donate_anonymous = params[:lender_item_condition][:donate_anonymous]
          @lit.trade = params[:lender_item_condition][:trade]
          @lit.trade_item = params[:lender_item_condition][:trade_item]
          @lit.agreed_number_of_days = params[:lender_item_condition][:agreed_number_of_days]   
          @lit.agreed_number_of_hours = params[:lender_item_condition][:agreed_number_of_hours]   
          @lit.indefinite_duration = params[:lender_item_condition][:indefinite_duration]
          @lit.present_during_borrowing_period = params[:lender_item_condition][:present_during_borrowing_period]   
          @lit.entire_period = params[:lender_item_condition][:entire_period]   
          @lit.partial_period = params[:lender_item_condition][:partial_period]   
          @lit.provide_proper_use_training = params[:lender_item_condition][:provide_proper_use_training]   
          @lit.specific_conditions = params[:lender_item_condition][:specific_conditions]   
          @lit.remote_ip = params[:lender_item_condition][:remote_ip]   
          @lit.comment = params[:lender_item_condition][:comment]
          @lit.save
    		  result_success = true
          else
    		
    		  @lit = LenderItemConditions.find(lit_id)
				  result_success = @lit.update(lender_item_condition_params)
          end
				
          if result_success
            @user = User.find(params[:lender_item_condition][:user_id])
	        	sign_in(@user)
            session[:LITid] = true
            session[:LICid] = true
            render  :template =>'lender_item_conditions/show', :locals => {:id => nil }
          else    
            session[:LITid] = true
            render  :template =>'lender_transfers/show', :locals => {:id => nil }
          end            
			
  end

  # DELETE /lender_item_conditions/1
  # DELETE /lender_item_conditions/1.json
  def destroy
    @lender_item_condition.destroy
    respond_to do |format|
      format.html { redirect_to lender_item_conditions_url, notice: 'Lender item condition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lender_item_condition
    if  params[:lender_item_condition_id]
      @lender_transfer = LenderItemCondition.find(params[:lender_item_condition_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lender_item_condition_params
      params.require(:lender_item_condition).permit(:item_id, participant_id, :for_free, :available_for_purchase, 
      :available_for_purchase_amount, :small_fee, :small_fee_amount, :available_for_donation, :donate_anonymous, 
      :trade, :trade_item, :agreed_number_of_days, :agreed_number_of_hours, :indefinite_duration, :present_during_borrowing_period, 
      :entire_period, :partial_period, :provide_proper_use_training, :specific_conditions, :security_deposit_amount, :security_deposit, 
      :remote_ip, :comment)
    end
end
