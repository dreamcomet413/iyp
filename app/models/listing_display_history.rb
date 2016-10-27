class ListingDisplayHistory < ActiveRecord::Base
  belongs_to :search_history
  has_many :num_display_histories
  belongs_to :listing
end
