class Abuse < ActiveRecord::Base
  def self.warning_abuse(ip, opts)
    where{|s| (a.created_at >= ABUSE_CONFIG['search_history']['interval_in_minutes'].minutes.ago) & (s.ip == ip)}.where(opts).last
  end

  def self.create_uniq(args)
    unless where{|a| (a.created_at >= ABUSE_CONFIG['abuse']['interval_in_minutes'].minutes.ago) & (a.ip == args[:ip])}.count > 0
      create args
    end
  end

  def self.number_of_abuses(ip)
    where{ |a| (a.created_at > (2 * ABUSE_CONFIG['abuse']['interval_in_minutes']).minutes.ago) & (a.ip == ip)}.count
  end
end

