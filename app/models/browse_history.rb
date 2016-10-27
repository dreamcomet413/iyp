class BrowseHistory < ActiveRecord::Base
  belongs_to :app
  has_many :search_histories
end
