class ImproveListing < ActiveRecord::Base
  belongs_to :listing
  attr_accessible :term_num_nis, :comment, :listing_id
end
