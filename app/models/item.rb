class Item < ApplicationRecord
 belongs_to :participant
 has_many :item_images, :dependent => :destroy
 
 attr_accessor :field_changed
 
 
 
end
