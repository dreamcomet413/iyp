class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :listing_display_histories
  has_many :improve_listings
end
