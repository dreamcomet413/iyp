module RestrictAccess
  def self.included(base)
    base.before_filter :restrict_access_for_ip
  end

  def restrict_access_for_ip
    return unless blocked_ip(request.remote_ip)
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403.html", :status => :forbidden }
      format.xml  { head :forbidden }
      format.any  { head :forbidden }
    end
  end

  protected

  def blocked_ip(ip)
    config = Widget::Application.config
    users_country_is_blocked(config, ip)
  end
  
  def users_country_is_blocked(config, ip)
    if config.respond_to? :restrict_access_from_all_countries_except_USA_and_Canada 
      config.restrict_access_from_all_countries_except_USA_and_Canada && 
        !["US", "CA"].include?(user_coutry_code(ip))
    elsif config.respond_to? :allow_access_only_from
      !config.allow_access_only_from.include?(user_coutry_code(ip))
    elsif config.respond_to? :restrict_access_only_from
      config.restrict_access_only_from.include?(user_coutry_code(ip))
    else
      false
    end
  end

  def user_coutry_code(ip)
    Geokit::Geocoders::MultiGeocoder.geocode(ip).country_code
  end
end

