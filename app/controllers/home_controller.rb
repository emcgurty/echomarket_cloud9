class HomeController < ApplicationController
    # All none database calls
		
	def echomarket_instructions 
	end
	
	def echomarket_agreement
	end

	def about
	end
	
	def show
    flash.notice =""
	if params[:id]  

    	case params[:id] 
    	when 'agreement' 
    		flash.notice = "Nitty-gritty. The EchoMarket Agreement" 
    		render :template => "home/echomarket_agreement" 
    	when 'instructions' 
    		flash.notice = "How EchoMarket Works" 
    		render :template => "home/echomarket_instructions" 
    	when 'information' 
    		flash.notice = "Your current EchoMarket User Information" 
    		render :template => "users/user_information"   
    	when 'about' 
    		flash.notice = "Please read the following information" 
    		render :template => "home/about"   
    		
    	else 
    	end 
    
	end 
	end	
end
