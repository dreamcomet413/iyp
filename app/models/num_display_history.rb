class NumDisplayHistory < ActiveRecord::Base
  belongs_to :listing_display_history
  has_many :num_match_histories
  attr_accessible :app_id, :num_display_history_id, :term_num, :listing_id, :ip, :listing_display_history_id

  def self.too_much_requests?(ip)
    where{|s| (s.created_at >= ABUSE_CONFIG['num_display']['interval_in_minutes'].minutes.ago) & (s.ip == ip)}.count > ABUSE_CONFIG['num_display']['allowed_count']
  end

  def self.too_much_since_last_abuse?(ip)
    last_abuse = Abuse.where(ip: ip).last.created_at
    where {|s| (s.created_at > last_abuse) & (s.ip == ip) }.count > ABUSE_CONFIG['num_display']['allowed_count']
  end

  def self.before_first_abuse?(ip)
    threshold = ABUSE_CONFIG['num_display']['interval_in_minutes']
    allowed_count = ABUSE_CONFIG['num_display']['allowed_count']
    abuse = Abuse.where { |a|
      (a.created_at >= threshold.minutes.ago) &
      (a.num_displays == 1) &
      (a.ip == ip)
    }.first
    return false if abuse
    where { |s|
      (s.created_at >= threshold.minutes.ago) &
      (s.ip == ip)
    }.count >= allowed_count
  end

  def self.after_first_abuse?(ip)
    threshold = ABUSE_CONFIG['num_display']['interval_in_minutes']
    allowed_count = ABUSE_CONFIG['num_display']['allowed_count']
    abuse = Abuse.where { |a|
      (a.created_at >= threshold.minutes.ago) &
      (a.num_displays == 1) &
      (a.ip == ip)
    }.first
    return false unless abuse
    where { |s|
      (s.created_at >= abuse.created_at) &
      (s.ip == ip)
    }.count >= allowed_count
  end

  def self.still_banned?(ip)
    ban_threshold = ABUSE_CONFIG['num_display']['ban_period_in_minutes']
    abuse = Abuse.where { |a|
      (a.created_at >= ban_threshold.minutes.ago) &
      (a.num_displays == 2) &
      (a.ip == ip)
    }.first
    !abuse.nil?
  end

end
