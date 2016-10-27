class SearchHistory < ActiveRecord::Base
  belongs_to  :browse_history
  has_many    :listing_display_histories

  def self.too_much_requests?(ip)
    where{|s| (s.created_at >= ABUSE_CONFIG['search_history']['interval_in_minutes'].minutes.ago) & (s.ip == ip)}.count > ABUSE_CONFIG['search_history']['allowed_count']
  end

  def self.too_much_since_last_abuse?(ip)
    last_abuse = Abuse.where(ip: ip).last.created_at
    where {|s| (s.created_at > last_abuse) & (s.ip == ip) }.count > ABUSE_CONFIG['search_history']['allowed_count']
  end


  def self.before_first_abuse?(ip)
    threshold = ABUSE_CONFIG['search_history']['interval_in_minutes']
    allowed_count = ABUSE_CONFIG['search_history']['allowed_count']
    abuse = Abuse.where { |a|
      (a.created_at >= threshold.minutes.ago) &
      (a.searches == 1) &
      (a.ip == ip)
    }.first
    return false if abuse
    where { |s|
      (s.created_at >= threshold.minutes.ago) &
      (s.ip == ip)
    }.count >= allowed_count
  end

  def self.after_first_abuse?(ip)
    threshold = ABUSE_CONFIG['search_history']['interval_in_minutes']
    allowed_count = ABUSE_CONFIG['search_history']['allowed_count']
    abuse = Abuse.where { |a|
      (a.created_at >= threshold.minutes.ago) &
      (a.searches == 1) &
      (a.ip == ip)
    }.first
    return false unless abuse
    where { |s|
      (s.created_at >= abuse.created_at) &
      (s.ip == ip)
    }.count >= allowed_count
  end

  def self.still_banned?(ip)
    ban_threshold = ABUSE_CONFIG['search_history']['ban_period_in_minutes']
    abuse = Abuse.where { |a|
      (a.created_at >= ban_threshold.minutes.ago) &
      (a.searches == 2) &
      (a.ip == ip)
    }.first
    !abuse.nil?
  end


end

