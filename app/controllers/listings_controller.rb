require 'rubygems'
require 'geokit'

class ListingsController < ApplicationController  
  include DynamicPhone

  before_filter :calculate_searches_from_user_ip_json
  before_filter :calculate_num_display_histories_from_user_ip_json

  respond_to :json
  before_filter :check_secret_key, :only => :index

  # XXX this method is horrifically complex, and needs abstracting out to
  # several child/private methods with reasonable amounts of passing data around.
  #
  # XXX Also, this shares an absolute boatload of code with AdsController, so
  # some of it should be abstracted to a base controller.
  #
  # The benefit of doing this will be that each individual method will be
  # testable for both functionality and performance, and it'll be much easier
  # to change for future developers.
  #
  def index
    # Getting previously saved suggestions results if exists    
    begin
      puts "get Json redis #{cookies[:browse_history_id]}"
      results = JSON.parse REDIS.get(cookies[:browse_history_id])
    rescue TypeError
      results = []
    end
    # Getting GEO IP information
    par = {}
    par[:pt] = GeoLocation.get_location(request.remote_ip, params[:geolocation])
   
    # If exists ?
    result = {}
    # Searching params[:what] text search within suggestions results
    results.each do |suggestion|
      result = suggestion if suggestion.value?(params[:what])
    end
    par[:rows] = 10

    # Times for phone availability.
    # XXX This probably needs to account for timezones.
    day = Time.now.strftime("%a").downcase
    now_time = (Time.now.strftime("%H").to_i * 60) + (Time.now.strftime("%M").to_i)
    now_plus_5min = ((Time.now + 5.minutes).strftime("%H").to_i * 60) + (Time.now + 5.minutes).strftime("%M").to_i
    par[:fq] = ["{!cache=false cost=20} #{day}_start:[* TO #{now_time}] AND #{day}_end:[#{now_plus_5min} TO *]"]
    #search type
    search_type = nil
    # If Category is selected from Suggestions
    if result.has_key?("cat_category")
      # logger.debug "CATEGORY"
      # logger.debug result
      par[:q] = "\"#{params[:what]}\"" unless params[:what].blank?
      unless params[:where].nil? or params[:where].empty?
        statecity = params[:where].split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
      search_type = 1
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      # making call to SOLR
      response = solr.get 'listings', :params => par
    # If Company is Selected from Suggestions
    elsif result.has_key?("company")
      # logger.debug "COMPANY"
      par[:q] = "company:\"#{params[:what]}\"" unless params[:what].blank?
      #par[:phrases] = { :company => params[:what] }
      if result["categories"]
        #par[:phrases] = { :categories => result["categories"] }
         result["categories"].each do |cat|
           par[:q] << " OR categories:\"#{cat}\""
         end
      end
      par[:qf] = "company^20 categories^5"
      par[:pf] = "company^20 categories^5"
      unless params[:where].nil? or params[:where].empty?
        statecity = params[:where].split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      search_type = 2
      response = solr.get 'listings', :params => par
    # if neither a Company nor Category was selected from suggestions (Free text)
    else
      # logger.debug "FREE TEXT"
      par[:q] = "#{params[:what]}"
      unless params[:where].nil? or params[:where].empty?
        statecity = params[:where].split(',')
        state_tmp = statecity[1] || "\"\""
        state_tmp = state_tmp.lstrip if state_tmp
        city_tmp = statecity[0] || "\"\""
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{state_tmp}\") OR (service_area:City AND city:\"#{city_tmp}\" AND state:\"#{state_tmp}\") OR (service_area:Zip AND state:\"#{state_tmp}\" AND city:\"#{city_tmp}\")"
      end
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      search_type = 3
      response = solr.get 'listingsfree', :params => par
    end

    # LOGGING ************************************************
    # Saving log of Searching
    search_history_params = {
      :keywords => params[:what],
      :geo => params[:where],
      :app_id => cookies[:app_id],
      :browse_history => BrowseHistory.find(cookies[:browse_history_id]),
      :ip => request.remote_ip,
      :search_type => search_type
    }
                        
    puts "params = #{search_history_params}"
    search = SearchHistory.create(search_history_params)    
    puts  REDIS.set(cookies[:browse_history_id].to_s+"_search_id", search.id)   
    json_response = JSON.parse(response)
    listings = json_response["response"]["docs"]

    #Gettings Listings Ids for logging
    ids = []
    listings.each do |listing|
      id = listing.select { |key, value| key.to_s.match(/^id/) }
      ids.push(id)

      # Use dynamic phone
      #
      # Start—Reservation of multiple Numbers
      listing["term_num"], listing["solr_term_num"] = extract_phone_number(listing, mobile_phone: mobile_device?)
      # End--- Reservation of multiple numbers
    end

    ## saving ads listings
    position = 1
    begin
      ids_ads = JSON.parse REDIS.get(cookies[:browse_history_id].to_s+"_search_id_ads")
    rescue
      ids_ads = nil
    end

    puts "id ads = #{ids_ads}"
    unless ids_ads.blank?
      ids.each do |pair|
        # found = Listing.find(pair["id"])
        found_id = pair["id"]
        unless search.id.blank?
          l = ListingDisplayHistory.create({:search_history_id => search.id,
              :listing_id => found_id,
              :position => position,
              :app_id => cookies[:app_id],
              :ad_flag => 1})
          puts "listinngs = #{l}"
          position = position + 1         
        end
      end
    end
    
    # Saving log of Listings
    position = 1
    ids.each do |pair|
        begin
          # It can be removed in the future if no validation of existance in listings table is needed.
          #
          # found = Listing.find(pair["id"])
          found_id = pair["id"]
          l = ListingDisplayHistory.create({ :search_history_id => search.id,
                                             # :listing_id => found.id,
                                             :listing_id => found_id,
                                             :position => position,
                                             # :app_id => cookies[:app_id]})
                                             :app_id => cookies[:app_id]})
          position = position + 1

          # Add listing_disp"]y_histories_id to response
          # listings.select{|l| l["id"].to_s == found.id.to_s}[0].merge!({:listing_display_histories_id => l.id})
          listings.select{|l| l["id"].to_s == found_id.to_s}[0].merge!({:listing_display_histories_id => l.id})
        rescue ActiveRecord::RecordNotFound
          logger.error "Listing not found #{pair["id"]}"
        end
    end
    REDIS.set(cookies[:browse_history_id].to_s+"_search_id_ads", nil)
    # END LOGGING ************************************************

    # Respond with error if all numbers are reserved
    if false && listings.count > 0 && listings.all?{|item| item["term_num"] == nil}
      begin
        WarningMailer.heavy_server_load.deliver
      ensure
        respond_with({error: "Heavy Server Load" })
      end
    else
      respond_with listings
    end
  end

  def update_reserved_number
    num_type = mobile_device? ? "4" : params["num_type"]
    if oldest_record = NumMatch.oldest_for(num_type: num_type)
      # Start—Re-serving individual Numbers
      oldest_record.update_attribute :expires, Time.now + 1.minutes
      # End--- Re-serving individual Numbers
      respond_to { |f| f.json { render json: oldest_record } }
    else
      Abuse.create_uniq(ip: request.remote_ip, num_displays: 1, app_id: cookies[:app_id])
      respond_with({error: "Heavy Server Load"}, status: :forbidden, location: nil)
    end
  end

  def update_clicked_phone_number
    ActiveRecord::Base.transaction do
      if num_match = NumMatch.find_by_display_num(params[:display_num])

        new_num_disp_history = NumDisplayHistory.create({
          :listing_display_history_id => params["listing_display_histories_id"],
          :listing_id => params["solr_listing_id"],
          :app_id => cookies[:app_id],
          :ip => request.remote_ip
        })

        num_match.update_attributes({
          :app_id => cookies[:app_id],
          :num_display_history_id => new_num_disp_history.id,
          :term_num => params["solr_term_num"],
          :listing_id => params["solr_listing_id"],
          :ip => request.remote_ip
        })
      end
    end
    render :nothing => true
  end

  protected

  def calculate_searches_from_user_ip_json
    ip = request.remote_ip
    if SearchHistory.still_banned?(ip)
      respond_with({error: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    elsif SearchHistory.after_first_abuse?(ip)
      Abuse.create(ip: ip, app_id: cookies[:app_id], searches: 2)
      respond_with({error: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    elsif SearchHistory.before_first_abuse?(ip)
      Abuse.create(ip: ip, app_id: cookies[:app_id], searches: 1)
      respond_with({warning: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    end
  end

  def calculate_num_display_histories_from_user_ip_json
    ip = request.remote_ip
    if NumDisplayHistory.still_banned?(ip)
      respond_with({error: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    elsif NumDisplayHistory.after_first_abuse?(ip)
      Abuse.create(ip: ip, app_id: cookies[:app_id], num_displays: 2)
      respond_with({error: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    elsif NumDisplayHistory.before_first_abuse?(ip)
      Abuse.create(ip: ip, app_id: cookies[:app_id], num_displays: 1)
      respond_with({warning: "Prevent Spam Attack"}, status: :forbidden, location: nil)
    end
  end
end

