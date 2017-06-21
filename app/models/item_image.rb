class ItemImage < ApplicationRecord
	belongs_to :item
	
	attr_accessor  :uploaded_picture, :item_type, :name_prefix
  before_save :uploaded_picture, :set_dates  
  
  def uploaded_picture=(picture_field)
    unless (picture_field.blank?)
      logger.debug "TODO Have to manage errors here"
      #begin
      name =  name_prefix.to_s + '_' + File.basename(picture_field.original_filename).gsub(/[^\w._-]/, '')
      directory = './app/assets/images/'  +  item_type.to_s
      # create the file path
      path = File.join(directory, name)
      # write the file -- b is for binary
      File.open(path, "wb") { |f| f.write(picture_field.read) }
      self.image_file_name = name
      self.image_content_type = picture_field.content_type.chomp
      self.image_width = 0
      self.image_height = 0
      #rescue
      #end
      
    end
  end

  def set_dates
    self.created_at = Time.current
    self.updated_at = Time.current
  end  

end

