class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

    # GET /searches/1
  # GET /searches/1.json
  def show
    
      if params[:id]
        unless session[:username].nil?
        is_user_signed_in('Searches/Show')  
        @search_history = Search.find_by(user_id: getUserID)
        end   
        render 'searches/search_items', search_history: @search_history
      
      end      
  end

  
  def create
    ## Not tested
    if params[:search]
      
        @blWhereString = nil
        @part_delimited = nil
        @partWhereString = nil
        @keyWhereString = nil
        @postalWhereString = nil
        @catWhereString = nil
        @datesWhereString = nil
     

    if params[:search][:selection_made]
      if params[:search][:selection_made].to_s == 'yes'
          @get_search_history = @search_history = Search.find_by(id: params[:search][:id])
          params[:search][:lender_or_borrower] = @get_search_history.lender_or_borrower
          params[:search][:keyword] = @get_search_history.keyword
          params[:search][:postal_code] = @get_search_history.postal_code
          params[:search][:category_id] = @get_search_history.category_id
          params[:search][:start_date] = @get_search_history.start_date
          params[:search][:end_date] = @get_search_history.end_date
      end
    end  
          
    is_user_signed_in('Searches/Create')
    
    @search = Search.create(search_params)
    unless params[:search][:search_name].blank? || params[:search][:selection_made].to_s == 'yes'
      # only save if search name blanks or when use using existing search
      @search.save
    end  
    
    @search_history = Search.find_by(user_id: getUserID)
    
      #  Find all Items that have participant id
      if getCommunityID
        @get_community_participants  = Item.joins(:participant)
            .where("participants.community_id = :cid AND participants.is_active = 1", {cid: getCommunityID})
      else  
        @get_community_participants  = Item.joins(:participant)
            .where("participants.community_id = -9 AND participants.is_active = 1")
      end  
    
        if @get_community_participants
          @get_community_participants.each do |p|
          if @part_delimited.nil? 
              @part_delimited = "'"
          else 
              @part_delimited.concat("'")
          end    
          @part_delimited.concat(p.participant_id.to_s)
          @part_delimited.concat("'")
          @part_delimited.concat(",")
          
          end
        else
        end 
    
        @part_delimited = @part_delimited.chop! unless @part_delimited.nil?  ## remove the last comma
        logger.debug "@part_delimited"
        logger.debug @part_delimited
        
        unless @part_delimited.nil?
          @partWhereString = "participants.participant_id IN ("
          @partWhereString.concat(@part_delimited)
          @partWhereString.concat(") ")
        end
        
        logger.debug "@partWhereString"
        logger.debug @partWhereString
        
        unless @partWhereString.nil?
        
        unless params[:search][:keyword].blank?
        
          @trimKeyWord = params[:search][:keyword].strip  #removes trailing and leading whitespace
          @keyWhereString = " ( items.item_model LIKE '%"
          @keyWhereString.concat(@trimKeyWord)
          @keyWhereString.concat("%'")
          @keyWhereString.concat(" OR ")
          @keyWhereString.concat(" items.item_description LIKE '%" )
          @keyWhereString.concat(@trimKeyWord)
          @keyWhereString.concat("%' )")
          
        end
        
        unless params[:search][:postal_code].blank?
           @trimPostal = params[:search][:postal_code].strip
           @postalWhereString = " ( addresses.address_type = 'primary' AND addresses.postal_code LIKE '"
           @postalWhereString.concat(@trimPostal)
           @postalWhereString.concat("%') ")
        else
           @postalWhereString = " ( addresses.address_type = 'primary' ) "
        end

        unless params[:search][:category_id].blank? || params[:search][:category_id].nil?
          unless params[:search][:category_id].to_s == '-2'
          @catWhereString = " items.category_id = "
          @catWhereString.concat(params[:search][:category_id].to_i)
          end
        end
        
        unless params[:search][:lender_or_borrower].blank?
          if params[:search][:lender_or_borrower] == '1'
              @blWhereString = " items.item_type = 'lend'"
          else
              @blWhereString = " items.item_type = 'borrow'"
          end  
        end
        
        unless params[:search][:start_date].blank? || params[:search][:end_date].blank?
          @datesWhereString  = " items.created_at >= '" 
          @datesWhereString.concat(params[:search][:start_date])
          @datesWhereString.concat("' AND items.created_at <= '")
          @datesWhereString.concat(params[:search][:end_date])
          @datesWhereString.concat("'")
        end  
        
        
        @buildWhereClause = nil
        @buildWhereClause = @partWhereString 
        @buildWhereClause.concat(" OR ").concat(@keyWhereString) unless @keyWhereString.nil?
        @buildWhereClause.concat(" OR ").concat(@postalWhereString) unless @postalWhereString.nil?
        @buildWhereClause.concat(" OR ").concat(@catWhereString) unless @catWhereString.nil?
        @buildWhereClause.concat(" OR ").concat(@datesWhereString) unless @datesWhereString.nil?
        @buildWhereClause.concat(" OR ").concat(@blWhereString) unless @blWhereString.nil?          
        end
        logger.debug "@buildWhereClause"
        logger.debug @buildWhereClause
        
        @items = Item.joins(participant: [:addresses])
                .where(@buildWhereClause)
                .distinct
        
        image_array = Array.new
        @item_image_array = Array.new
        @items.each do |im|
          @hold = ItemImage.find_by(item_id: im.item_id)
          image_array << @hold.image_file_name
          image_array << @hold.item_image_caption
          @item_image_array << image_array
          @hold = nil
        end  
        
    end
      
      render 'searches/search_items' ,  search: @search, item: @items, 
                                        item_image_array: @item_image_array, search_history: @search_history
        
  end  
  
  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    if params[:search]
      
    end      
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_search
    end

    def search_params
      params.require(:search).permit(:keyword, :postal_code, :category_id, :start_date, :end_date,
       :lender_or_borrower, :user_id, :zip_code_radius, :remote_ip, :search_name, :is_community, :found_zip_codes)
    end
end

