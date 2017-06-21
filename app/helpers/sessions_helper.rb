module SessionsHelper
  
  ## Would rather put these in def intialize or class
  
  @role_id = nil
  @participant_id = nil
  @user_id = nil
  @username = nil
  @user_alias = nil
  @user_type = nil
  @community_id = nil
  @community_name = nil
  @is_creator = nil
  @threeStrikesYourOut = -1
  @user_email = nil;
  @display_alternative_email = -1
  @userAlternativeEmail = nil
  
  def sign_in(user)
    
  	
	cookies.permanent[:remember_token] = user.remember_token
	current_user = user
	
	@role_id = current_user[:role_id]
	@user_id = current_user[:user_id]
	@user_alias = current_user[:user_alias]
	@username = current_user[:username]
	@user_type = current_user[:user_type]
	@user_type = userIsWhichType
	@user_email = current_user[:email]
	@part = Participant.where(["user_id = :u and goodwill = 1 and  age_18_or_more = 1", { u: @user_id.to_s }]).first
	
	if @role_id > 0
		@community_name = current_user[:community_name]
		
	end	
		
		if @part

				@participant_id = @part.participant_id.to_s
				@community_id = @part[:community_id].to_s
				@is_creator = @part[:is_creator].to_i
				@display_alternative_email = @part[:display_alternative_email]
        @userAlternativeEmail = @part[:email_alternative]
			
		end	
		@part = nil

  end

 def getdisplay_alternative_email
	@display_alternative_email
 end
 
 def getuserAlternativeEmail
	@userAlternativeEmail
 end

  def getEmail
	@user_email
  end
 

 
 def getUserType
	@user_type
 end
 
 def getRoleID
	@role_id
 end
  
  def getParticipantID
	@participant_id
  end
  
  def getUserID
	@user_id
  end
 	
  def getUserAlias
	@user_alias
  end	
  
  def getCommunityID
   @community_id
  end
  
  def getIsCreator
    @is_creator
  end

def getCommunityName
  @community_name
end  
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end
  
  def sign_out
	  @role_id = nil
	  @participant_id = nil
	  @user_id = nil
	  @username = nil
	  @user_alias = nil
	  @user_type = nil
	  @community_id = nil
	  @community_name = nil
	  @is_creator = nil
      
	  current_user = nil
      cookies.delete(:remember_token)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def store_location
    logger.debug " Content of request.fullpath"
    logger.debug request.fullpath
    session[:return_to] = request.fullpath
  end
  
   def get_random  ##  should be in application controller
    length = 40
    characters = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
    @id = SecureRandom.random_bytes(length).each_char.map do |char|
      characters[(char.ord % characters.length)]
    end.join
    @id
  end
  
  private
    
    def user_from_remember_token
      remember_token = cookies[:remember_token]
      User.find_by_remember_token(remember_token) unless remember_token.nil?
    end
    
    def clear_return_to
      session.delete(:return_to)
    end
	
	 def userIsWhichType 
		returnType = nil
		if ((@user_type.include?("lend") == true) && (@user_type.include?("borrow") == false)) 
		  returnType = "lend";
		elsif ((@user_type.include?("borrow") == true) && (@user_type.include?("lend") == false)) 
		  returnType = "borrow";
		elsif ((@user_type.include?("borrow") == true) && (@user_type.include?("lend") == true)) 
		  returnType = "both";
		end  
    
		return returnType
	
	end
  
end