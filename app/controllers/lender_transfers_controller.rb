class LenderTransfersController < ApplicationController
  before_action :set_lender_transfer, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def lender_transfer
  
    is_user_signed_in('LT')
    session_item_id = (session[:item_id] == '-1' ? nil : session[:item_id])  
    
    session[:cpID] = true 
	  session[:LITid] = true 
    
    if getParticipantID && session_item_id 
		  @lender_transfer = LenderTransfer.find_by(participant_id: getParticipantID, item_id: session_item_id ) 
    elsif getParticipantID && !session_item_id 
		  @lender_transfer = LenderTransfer.find_by(participant_id: getParticipantID) 
    elsif !getParticipantID && session_item_id 
		  @lender_transfer = LenderTransfer.find_by(item_id: session_item_id ) 
    else 
		  @lender_transfer = LenderTransfer.new 
    end 

  end    
	
  def new
  end

  def edit
  end

  def create
  end

  def update 
      
      pid = nil
      iid = nil
      lit_id = nil
      
      if params[:lender_transfer][:lender_transfer_id]
        lit_id = params[:lender_transfer][:lender_transfer_id]
      end  
      
      if params[:lender_transfer][:participant_id]
        pid = params[:lender_transfer][:participant_id]
      else
        pid = getParticipantID
      end  
      
      if params[:lender_transfer][:item_id]
        iid = params[:lender_transfer][:item_id]
      else
        iid = session[:item_id]
      end  
      
      result_success = false
      @lender_transfer = nil
      
          if lit_id
    		  ##  Create a new record. Params doesn't work on create??
    		  @lender_transfer = LenderTransfer.new
    		  
    		  @lender_transfer.participant_id = pid
    		  @lender_transfer.item_id = iid
    		  @lender_transfer.borrower_comes_to_which_address = params[:lender_transfer][:borrower_comes_to_which_address]
          @lender_transfer.meetBorrowerAtAgreed = params[:lender_transfer][:meetBorrowerAtAgreed]   
          @lender_transfer.meetBorrowerAtAgreedLenderChoice  = params[:lender_transfer][:meetBorrowerAtAgreedLenderChoice]   
          @lender_transfer.meetBorrowerAtAgreedBorrowerChoice = params[:lender_transfer][:meetBorrowerAtAgreedBorrowerChoice]   
          @lender_transfer.meetBorrowerAtAgreedMutual = params[:lender_transfer][:meetBorrowerAtAgreedMutual]   
          @lender_transfer.will_deliver_to_borrower = params[:lender_transfer][:will_deliver_to_borrower]   
          @lender_transfer.thirdPartyPresence = params[:lender_transfer][:thirdPartyPresence]   
          @lender_transfer.thirdPartyPresenceLenderChoice = params[:lender_transfer][:thirdPartyPresenceLenderChoice]   
          @lender_transfer.thirdPartyPresenceBorrowerChoice  = params[:lender_transfer][:thirdPartyPresenceBorrowerChoice]   
          @lender_transfer.thirdPartyPresenceMutual = params[:lender_transfer][:thirdPartyPresenceMutual]   
          @lender_transfer.borrower_returns_to_which_address = params[:lender_transfer][:borrower_returns_to_which_address]   
          @lender_transfer.willPickUpPreferredLocation = params[:lender_transfer][:willPickUpPreferredLocation]   
          @lender_transfer.remote_ip = params[:lender_transfer][:remote_ip]   
          @lender_transfer.comment = params[:lender_transfer][:comment]
          @lender_transfer.save
    		  result_success = true
          else
    		
    		  @lit = LenderTransfer.find(lit_id)
				  result_success = @lender_transfer.update(lender_transfer_params)
          end
				
          if result_success
            session[:LITid] = true
            
            render  'lender_transfer'
          else    
            session[:LITid] = true
            render  'lender_transfers'
          end            
			
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lender_transfer
      if  params[:lender_transfer_id]
      @lender_transfer = LenderTransfer.find(params[:lender_transfer_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lender_transfer_params
      params.require(:lender_transfer).permit(:item_id, :participant_id, 
      :borrower_comes_to_which_address,  :meetBorrowerAtAgreed, :meetBorrowerAtAgreedLenderChoice, 
      :meetBorrowerAtAgreedBorrowerChoice, :meetBorrowerAtAgreedMutual, :will_deliver_to_borrower, 
      :thirdPartyPresence, :thirdPartyPresenceLenderChoice, :thirdPartyPresenceBorrowerChoice, 
      :thirdPartyPresenceMutual, :borrower_returns_to_which_address, :willPickUpPreferredLocation, 
      :remote_ip, :comment)
    end
end
