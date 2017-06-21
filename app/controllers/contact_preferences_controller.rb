class ContactPreferencesController < ApplicationController
  before_action :set_contact_preference, only: [:show, :edit, :update, :destroy]
  ##  How does the borrower or lender wish to be contacted
  # GET /contact_preferences
  # GET /contact_preferences.json
  def index
    @contact_preferences = ContactPreference.all
  end

  # GET /contact_preferences/1
  # GET /contact_preferences/1.json
  def show
  end
  
  def user_contact_preferences
  end


  def new
  end


  def edit
  end

  # POST /contact_preferences
  # POST /contact_preferences.json
  def create
  end

  # PATCH/PUT /contact_preferences/1
  # PATCH/PUT /contact_preferences/1.json
  def update
  end

  # DELETE /contact_preferences/1
  # DELETE /contact_preferences/1.json
  def destroy
  end

  private

    def set_contact_preference
    end  
	
    def contact_preference_params
      ## Don't include foreign keys
      params.require(:contact_preference).permit(:item_id, :user_id, :use_which_contact_address,
                     :contact_by_chat, :contact_by_email, :contact_by_home_phone, :contact_by_cell_phone,  
                     :contact_by_alternative_phone, :contact_by_Facebook, :contact_by_Twitter,  :contact_by_Instagram, 
                     :contact_by_LinkedIn,  :contact_by_other_social_media,  :contact_by_other_social_media_access)
                    
    end
end
