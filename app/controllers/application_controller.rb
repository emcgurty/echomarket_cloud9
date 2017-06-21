class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # per: https://github.com/plataformatec/devise/issues/4085... getting Can't verify CSRF token authenticity.error
  # Was getting error becuase of :no content
  #protect_from_forgery_with prepend: 
  include SessionsHelper
  
  def is_user_signed_in(whichView)
      
      unless session[:username].nil?
        @user = User.find_by(username: session[:username], is_active: 1) 
        sign_in(@user) 
      end
      
  end
  
    def delimit_user_type(userType)
     
     @hold_value = nil
	  
     if  userType.include?("lend") && userType.include?("borrow")
		  @hold_value = "lend;borrow"
     end

    if userType.include?("lend") && !userType.include?("borrow")
		@hold_value = "lend"
    end
	 
    if !userType.include?("lend") && userType.include?("borrow")
		@hold_value = "borrow"
    end
	 
	  @hold_value  
    end
  
end
