class WidgetController < ApplicationController

  before_filter :check_for_banned_user

  def index
    # app_id = params[:a] || 1

    # bh = BrowseHistory.create({
    #   # :app_id        => params[:a],
    #   :ip            => request.remote_ip, 
    #   :referring_url => request.referer
    #   # :referring_url => request.host
    #   # :referring_url => request.env['REQUEST_URI']
    # })

    # BrowseHistory.create({:app_id  => params[:a], :ip  => request.remote_ip })
    # Saved cookie for SearchHistory logging

    # temporary renaming app_id to app_id_wid1_0
    # cookies[:app_id_wid1_0] = params[:a]

    # old app_id:
    # cookies[:app_id] = params[:a]

    agent = Agent.new(request.user_agent)
    bh = BrowseHistory.create({
      :app_id        => cookies[:app_id],
      :ip            => request.remote_ip,
      :referring_url => request.referer,
      :os => agent.os,
      :browser => "#{agent.name} #{agent.version}",
      :device => request.user_agent[/\((.+?)\)/][1..-2]
    })

    cookies[:browse_history_id] = bh.id
    cookies['city'] ||= get_city_and_state
  end

  protected

  def get_city_and_state
    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    location.country_code == "US" ? "#{location.city}, #{location.state}" : "Seattle, Wa"
  end

  def check_for_banned_user  
    if SearchHistory.still_banned?(request.remote_ip)
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/spam.html", :status => :forbidden }
        format.xml  { head :forbidden }
        format.json { head :forbidden }
        format.any  { head :forbidden }
      end
    end
  end
end
