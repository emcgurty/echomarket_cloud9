class UserMailer < ApplicationMailer
 
  def welcome_email(user)
    @user = user
    @url  = 'http://echomarket.org/activate/' +  @user.reset_code
	  @hold_email = @user.email
	  @myemail = "echomarket_email"
    mail(to: @hold_email, subject: 'Thank you for registering at EchoMarket')
  end
  
  def password_changed_email(user, pd)
    @user = user
    @hold_email = @user.email
	  @myemail = "echomarket_email"
	  @pd = pd
    mail(to: @myemail, subject: 'Sought EchoMarket User Information')
  end
 
  def shout_to_borrower(item, l_alias)
   @lenderAlias = l_alias
   item.each do |itm|
   @hold_user_email = Participant.find_by(particpant_id: itm.participant_id).user_id 
   @email = User.find_by(user_id: @hold_user_email).email
   @item = itm   
   mail(to: @email, subject: "EchoMarket Borrower's Shout")
   end
  end

  def shout_to_lender(item, b_alias)
    @borrowerAlias = b_alias
    item.each do |itm|
    @hold_user_email = Participant.find_by(particpant_id: itm.participant_id).user_id 
    @email = User.find_by(user_id: @hold_user_email).email      
    @item = itm     
    mail(to: @email, subject: "EchoMarket Lender's Shout")
    end
  end
end
