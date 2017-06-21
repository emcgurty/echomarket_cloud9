class UserMailer < ApplicationMailer
 
  def welcome_email(user)
    @user = user
    @url  = 'http://echomarket.org/activate/' +  @user.reset_code
	  @hold_email = @user.email
	  @myemail = "emcgurty2@gmail.com"
    mail(to: @hold_email, subject: 'Thank you for registering at EchoMarket')
  end
  
  def password_changed_email(user, pd)
    @user = user
    @hold_email = @user.email
	  @myemail = "emcgurty2@gmail.com"
	  @pd = pd
    mail(to: @myemail, subject: 'Sought EchoMarket User Information')
  end


end
