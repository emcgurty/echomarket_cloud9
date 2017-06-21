class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  #before_action :set_user, only: [:user_registration, :user_login]
  
  
  def user_login_update
  end
  
  def index
    @users = User.all
  end

  def show

  session[:user_action].nil? ? session[:user_action] = params[:id] : "" 
  
  case session[:user_action] 
  when "app_options" 
  render :template => "users/app_options" 
  when "user_registration" 
  render :template => "users/user_registration" 
  when "user_login" 
  render :template => "users/user_login" 
  when "user_logout" 
      sign_out
      reset_session  
      flash.notice = "You have been successfully Logged Out. Hope all is well?" 
  render :template => "users/app_options"
  when "activate_user" 
  render :template => "users/app_options"
  when "community_registration"
    @community = Community.new
  render :template => "users/community_registration"  
  end 

  end
 
 
  # GET /users/new
  def new
    @user = User.new
  end
  
  def activate_user
 
  end
  
  # POST
def activate
      ### Called from a url only.  Assumption here is that reset_code will always be unique. Need to check previosly that reset_code is unique 
  @user = nil
  if request.post? 
	   ## test that username and password are not blank
    if params[:user][:reset_code]
		  logger.debug 'In User/activate'
			logger.debug params[:user][:reset_code]
		  @current_username = params[:user][:username]
		  @user = User.find_by_reset_code(params[:user][:reset_code])
			    if @user

					@user.reset_code = nil
					@user.activated_at = Time.current
					if @user.save(:validate => false)
					sign_in(@user)
				
					flash[:notice] = @current_username + ", you have been activated with EchoMarket, now you are required to accept the EchoMarket Agreement. "
					session[:editable] = -1
					render 'participants/user_agreement'
					else
				
					  ##  code if save failed
					end
				else
				
				  ## code if user not found
				end
		else
		    
		  flash[:notice] = "EchoMarket was unable to find your Activation record, please verify the provided link in your email."
			session[:user_action] = "activate_user"
			session[:reset_code] = params[:user][:reset_code]
			render 'users/app_options'
    end
  end  # close request.post
end  # close def
 
  def user_logout
  end
    
def user_login
  
    @resultsSuccess = false
	  @getReset_code = nil
	  @return_string = nil
    if request.post?
	
	   @hold_userName =  params[:user][:username].to_s
	   @hold_password =  params[:user][:password].to_s
	   @user = nil
	   
    unless (@hold_userName.empty? || @hold_password.empty?)
		 
		 reset_session
		 sign_out

     session[:item_id] = nil
		 ## because same seesion user may login in as someone else
		 @accept_results = nil
		 ## return either a User object or nil
		 @user = User.authenticate(params[:user][:username], params[:user][:password]) 

      unless @user
				flash[:notice] = "User name and/or password not found. Please try again." 
				@return_string = "login"
      else
			  @resultsSuccess = true
			  session[:username] = @hold_userName
      end

    if @resultsSuccess
			
          if @user[:reset_code].nil?   ## then user has activated
				    logger.debug "Activated_at NIL"
					begin
					session[:acceptID] = true
					rescue
					end
					sign_in(@user)
					@resultsSuccess = true
          else	
				    
				  flash[:notice] = @hold_userName + ", you have not completed your EchoMarket activation process.  Please check your email.  "  
					@return_string = "activate_user"
					@getReset_code = @user[:reset_code]
					@user = nil
					@resultsSuccess = false
					
          end
    end	

			if @resultsSuccess
								
				begin

					if getParticipantID.nil?
						flash[:notice] = @hold_userName + ", you need to aceept the EchoMarket Agreement"
						@return_string = "user_agreement" 
						@resultsSuccess = false
						else 
						session[:acceptID]  = true
						@resultsSuccess = true
					end
				rescue
				end
					
			
				if @resultsSuccess
					
				  ## Following seems repetitive, but difference in role driven features not complete
				  case getRoleID
					when 0  ## Individual not with a community.
					  @return_string = findWhatIsComplete
					when 1  ## A community creator
					  @return_string = findWhatIsComplete

                if (@return_string.nil?)  
						      @return_string = findWhatIsCommunityComplete
                end
					when 2  ## A member of a community
					  @return_string = findWhatIsComplete
				  end
				   
      case @return_string
				
				 when 'user_item'
				   	

				        @exisitng_items = Item.find_by(participant_id: getParticipantID)
				        if @exisitng_items.nil?
				          session[:complete] = false
				          redirect_to  :controller=> 'items', :action => 'new_item', :id => getParticipantID
				        else
				          session[:acceptID] = true
					        session[:partID] = true
					        session[:cpId] = true
					        session[:LICid] = true
					        session[:LITid] = true
                  if getCommunityID
                  redirect_to  :controller=> 'items', :action => 'borrowing_history', :id => 'all, all,' + getCommunityID
                  else 
                  redirect_to  :controller=> 'items', :action => 'borrowing_history', :id => 'all, all,' + getParticipantID
				          end
				        end
				         
				         

				  when "user_nae"
				    logger.debug "case user_nae"
				    session[:acceptID] = true
					  session[:partID] = false
					  session[:cpId] = false
					  session[:LICid] = false
					  session[:LITid] = false
					  session[:current_div] = "nae"
					  render :template => 'participants/main_user_detail'
					  
  		      
				  when "user_contact_preferences"
           session[:current_div] = "preference"				    
           redirect_to :controller => 'participants', :action => 'main_user_detail'
				  when "community_detail"
           session[:current_div] = "community"				    
           redirect_to :controller => 'participants', :action => 'main_user_detail'
				  when "lender_transfer"
				     session[:cpId] = true
					   session[:current_div] = "transfer"				    
           redirect_to :controller => 'participants', :action => 'main_user_detail'
				  when "lender_item_conditions"
				    session[:cpId] = true
					  session[:current_div] = "condition"				    
           redirect_to :controller => 'participants', :action => 'main_user_detail'
				  when "community_members"
           session[:current_div] = "community"	
           flash[:notice] = "You need to add members to your Community."
				   redirect_to :controller => 'participants', :action => 'main_user_detail'
      end
			end
				
			end ## close #resultSuccess
	    ## Username and password not found

		case @return_string
		 when "login"
			 session[:user_action] = "login"
			 render 'users/app_options'
		 when "activate_user"
		     session[:user_action] = "loginUser"
		     session[:reset_code] = @getReset_code
			   render 'users/app_options'
		 when "user_agreement"
	       render :template => 'participants/user_agreement' 
		end

	else 
		flash[:notice] = "Please provide a username and password"
		session[:user_action] = "login"
		render 'users/app_options'
    end
    end ## request_post  
	
end  # close user_login
	
   
  
  def app_options  ## This needs to be incorporated in show
   
   reset_session
   session[:username] = nil
   case params[:id]
   when "forgotUserName"
	session[:user_action] = "forgotUserName"
   when "forgotUserPassword"
	session[:user_action] = "forgotUserPassword"	
   when "userLogin"
	session[:user_action] = "userLogin"
   end
   
  end  # close app_option

  # GET /users/1/edit
  def edit
  end

  def create
    
	  flash[:notice] = nil
	  @user = User.new
    
    @user.username =   params[:user][:username]
    @user.password =   params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.email = params[:user][:email]
    @user.remote_ip =  params[:user][:remote_ip]
	  @user.user_type =  delimit_user_type(params[:user][:user_type]) unless params[:user][:user_type].nil?
	  @user.user_alias =   params[:user][:user_alias]
	  if params[:id] == 'community'
	    @user.role_id = 1 ## 2 is individual commpunity member
	    @user.community_name =   params[:user][:community_member][:community_name]
	  else
	    @user.role_id = 0
	  end   
      
    if @user.save(:validate => true) && @user.errors.empty?
    if params[:id] == 'community'
      ###  Could get params to work, pretty sure Cloud 9 is delayed in seeing nwe definition of params
      @cm = Community.new
      @cm.user_id = @user.user_id.to_s
      @cm.community_name = params[:user][:community_member][:community_name]
      @cm.first_name = params[:user][:community_member][:first_name]
      @cm.last_name = params[:user][:community_member][:last_name]
      @cm.remote_ip= params[:user][:remote_ip]
      @cm.save
    end
      
      @result = UserMailer.welcome_email(@user).deliver_now	   
	   logger.debug "WAS email sent?"
	   logger.debug @result
	   flash[:notice] = "Thanks for signing up! Please check your email, " + params[:user][:email] + ", to activate your account."
	   render 'users/app_options', user: @user
    else
      if @user.errors.count == 1
       flash[:notice] = "There was an error in your Registration, see below." 
      else
        flash[:notice] = "There were " + @user.errors.count.to_s + " errors in your Registration, please see below." 
      end        
       
      render 'users/user_registration', user: @user
    end
  end  


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html   redirect_to @user, notice: 'User was successfully updated.'  
        format.json   render :show, status: :ok, location: @user  
      else
        format.html   render :edit  
        format.json   render json: @user.errors, status: :unprocessable_entity  
      end
    end
  end  ## close update

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
     ## Cascade destroy
    @user.destroy  
    respond_to do |format|
      format.html   redirect_to users_url, notice: 'User was successfully destroyed.'  
      format.json   head :no_content  
    end
	reset_session
	sign_out
	session[:user_action] = "login"
	render 'users/app_options'
  end

def managePasswordChange
    
    if params[:user]
      @un = params[:user][:username].to_s
      @rs = params[:user][:reset_code].to_s
      @validate = validateUserNameResetCode(@un, @rs)
    
    if (@validate) 
      @validate.reset_code = nil
      @validate.activated_at  = Time.current
      @validate.password = params[:user][password]
      @validate.password _confirmation = params[:user][password_confirmation]
    
    
    if (@validate.save)
      flash[:notice] = params[:user][username].to_s + ", your password has been successfully changed.  Please login."
      session[:user_action] = "login"
    
    else
      flash[:notice] = params[:user][username].to_s + ", your password was not successfully changed.  Please try again."
      session[:user_action] = "login"
    
    end  
    else
    end  ## closes if validate
    
    else
      flash[:notice] = params[:user][username].to_s + ", your password was not successfully changed.  Please try again."
      session[:user_action] = "login"
    
    end ## closes if params
    
      render 'users/app_options'
    
end  
  	
  	
  private
    
	# Use callbacks to share common setup or constraints between actions.
    def set_user
	    # do not understand this yet
	    # read http://craftingruby.com/posts/2015/05/31/dont-use-before-action-to-load-data.html
	  if params[:user_id]
      @user = User.find(params[:user_id])
	  end 
	 
    end
		

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
	     params.require(:user)
	     .permit(:username, :email, :remote_ip, :user_alias, :user_type, :role_id, :password, :password_confirmation, :remote_ip)
	     .require(:community_member).permit(:community_name)
    end
	
  def user_member_params
	     params.require(:user).permit(:remote_ip, :community_member).require(:community_member).permit(:community_name, :first_name, :last_name)
  end
	
	def findWhatIsComplete

    @return_string = nil
    session[:partID] = false
    session[:LITid] = false
    session[:LICid] = false
    @partList = completeParticipantRecord
    if (@partList) 
      
      begin
        session[:partID] = true
      rescue
		    logger.debug "TODO session(:partID => true) failed"
      end
		
        if (@partList.display_alternative_address == 1)
          session[:displayPrimary] = true
        else 
          session[:displayPrimary] = false
        end
		
        if (@partList.display_address == 1) 
          session[:displayAlternative] = true
        else 
          session[:displayAlternative] = false
        end

        unless completeContactPreferences   ## returns recordSet
            @return_string = "user_contact_preferences" 

        else

              if @return_string.nil?
                session[:editable] = 1
                 case getUserType
                   when "borrow"
                     @return_string = "user_item"
                   when "lend" 
                    if (completeLIT.nil?)
                      @return_string = "lender_transfer" 
                    else 
                      session[:LITid] = true
                    end
                    
                    if  @return_string.nil?
                      if (completeLIC.nil?)
                        @return_string = "lender_item_conditions" 
                      else 
                        session[:LICid] = true      
                        @return_string = "user_item"  
                      end
                    end  
                  when "both"
                    if (completeLIT.nil?)
                      @return_string = "lender_transfer" 
                    else 
                      session[:LITid] = true
                    end
                    
                    
                    if  @return_string.nil?
                      if (completeLIC.nil?)
                        @return_string = "lender_item_conditions" 
                      else 
                        session[:LICid] = true      
                        @return_string = "user_item"  
                      end
                    end
      		    end  # close case
			        end  # close return_string.nil
			  
          end  # close  if (session[:cpId] == false)

    else 
      flash[:notice] = "Please provide the following EchoMarket 'Participant Information'"
      @return_string = "user_nae"
    end  ## close partList empty
	
	@return_string
	end  ## close def

  def findWhatIsCommunityComplete
	  @return_string = nil
	  @completeCM = -1
    @partList = completeParticipantRecord   ## returns .first
      if (@partList)
          session[:creatorDetailID] = true
      else       
		      session[:creatorDetailID] = true
		      session[:editable] = 1
          @return_string = "user_nae"  
      end

    if @return_string.nil?
      @completeCD = completeCommunityDetail  ## Is there are community record?
      if @completeCD
          ###  Get rid of these sessions 
          session[:comDetailID] = true
          session[:community_name] = @completeCD.community_name
		      session[:community_id] = @completeCD.community_id
          session[:editable] = 0
        else 

          session[:comDetailID] = true
          session[:comMemberDetailID] = true
          session[:editable] = 1
          @return_string = "community_detail"
      
      end
      
         
    end

    
	unless @return_string.nil?
      @completeCM = completeCommunityMemberRecord
      if (@completeCM > 1) 
		      session[:comDetailID] = true
          session[:comMemberDetailID] = true
          session[:editable] = 0
        else 
          session[:comDetailID] = true
          session[:comMemberDetailID] = true
          session[:editable] = 1
          @return_string = "community_members" 
      end  
	end 
    

	@return_string
  
  end

  def completeParticipantRecord
        begin
    	 logger.debug "getUserID in completeParticpantRecord"
    	 logger.debug getUserID
    	 @complete_part = Participant.where(["user_id = :u and first_name is not null", { u: getUserID }]).first
    	 rescue
    	 @complete_part = nil
        end
	 
   @complete_part
  end
  
  def completeContactPreferences
    
    currentItem = nil
    currentItem = session[:item_id] unless session[:item_id].nil?
    @results = nil

   
  if currentItem.nil?
		    @results = ContactPreference.where(["participant_id = :pid", { pid: getParticipantID }]).group("participant_id").order("participant_id").take
  else 
       @results = ContactPreference. where(["participant_id = :pid and item_id = :iid", { pid: getParticipantID, iid: session[:item_id] }]).group("participant_id").order("participant_id").take
  end
	

	 @results
   
  end
  
  def completeLIT
    
    @lit = nil
    logger.debug "LIT truths"
    #logger.debug session[:item_id]
    logger.debug getParticipantID
    
    
    if session[:item_id] && getParticipantID
     logger.debug "LIT1"
     @lit = LenderTransfer.where('participant_id =  ' + getParticipantID + ' and item_id = '  + session[:item_id])
    elsif session[:item_id] && getParticipantID.nil?
     logger.debug "LIT2"
     @lit = LenderTransfer.where('item_id = '  + session[:item_id])
    elsif session[:item_id].nil? && getParticipantID
     logger.debug "LIT3"
     @lit = LenderTransfer.find_by(participant_id: getParticipantID )
    end
    
    @lit
     
  end
  
  def completeLIC
    
    @lic = nil
    
   
    if session[:item_id] && getParticipantID
     @lic = LenderItemCondition.find_by(participant_id: getParticipantID, item_id: session[:item_id])
    elsif session[:item_id] && getParticipantID.nil?
     @lic = LenderItemCondition.find_by(item_id: session[:item_id])
    elsif session[:item_id].nil? && getParticipantID
     @lic = LenderItemCondition.find_by(participant_id: getParticipantID )
    end
    logger.debug "complee LIC QQQQQQQQ"
    logger.debug  @lic.nil?
    
    @lic
    

  end

  
  def completeCommunityMemberRecord
    logger.debug "getComID"
    logger.debug getCommunityID
    @member_record = Participant.where("community_id =  :comID", {comID: getCommunityID }).count(:first_name)
    if @member_record.nil?
      return 0
    else
      @member_record
    end  
      
  end
  
  def completeCommunityDetail
    @community_detail = Community.where("user_id =  :uId and is_active is not null", {uId: getUserID}).first
  end  
  
  def forgotUserPassword
    
    @set_reset_code = nil
    if params[:user][:email]
      @set_reset_code = validateEmail(params[:user][:email].to_s) ## returns that User record
    
      if (@set_reset_code) 
        if (@set_reset_code.user_id) 
            @set_reset_code.reset_code = get_random
            
            if (@set_reset_code.save)
                UserMailer.password_change_email(@user).deliver_now	 
            end
        end            
      end
    end  
    session[:user_action] = "login"
    render :template => "users/user_login" 
  end                

  def forgotUserName

      if params[:user][:password] && params[:user][:email]
        @pd = params[:user][:password].to_s
        @em = params[:user][:email].to_s
        @validate_input = validateEmailAndPassword(@em, @pd)
    
        if (@validate_input)
          flash[:notice] = "Your EchoMarket User Name is: " +  @valid_email.username.to_s
          session[:user_action] = "login"
        end
      end  

    render :template => "users/user_login" 

  end

  def validateEmailAndPassword(em, pw) 

    @return_value = false
    @valid_email = validateEmail(em)
    
    if (@valid_email) 
      @valid_email.authenticated?(pw)
    end  
  
  end
  
  def validateEmail(em) 
      @get_email = Users.find_by(email: em)
  end
  
  def validateUserNameResetCode(un, rc)
      @u = nil
      @u = User.where("username = " + un  + " and reset_code = " + rc)
  end

end