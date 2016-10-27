class NumMatch < ActiveRecord::Base
  self.primary_key = :display_num
  belongs_to :num_display_history
  attr_accessible :display_num, :expires, :num_type, :updated_at, :app_id, :num_display_history_id, :term_num, :listing_id, :ip

  scope :not_reserved, where{(expires < Time.now) | (expires == nil)}

  def self.oldest_for(condition)
    where(condition).
      where{(expires < Time.now) | (expires == nil)}.
      order("updated_at DESC").last
  end
end
