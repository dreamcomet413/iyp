class AdsController < ApplicationController
  include DynamicPhone

  respond_to :json
  before_filter :check_secret_key, :only => :index

  #XXX See notes @ ListingsController#index
  #
  def index
    # Getting previously saved suggestions results if exists
    begin
      results = JSON.parse REDIS.get(cookies[:browse_history_id])
    rescue TypeError
      results = []
    end
    # Searching params[:what] text search within suggestions results
    par = {}
    par[:pt] = GeoLocation.get_location(request.remote_ip, params[:geolocation])

    # If exists ?
    result = {}
    results.each do |suggestion|
      result = suggestion if suggestion.value?(params[:what])
    end
    par[:rows] = 6
    par[:fq] = ["ad_flag:1"]

    day = Time.now.strftime("%a").downcase
    now_time = (Time.now.strftime("%H").to_i * 60) + (Time.now.strftime("%M").to_i)
    now_plus_5min = ((Time.now + 5.minutes).strftime("%H").to_i * 60) + (Time.now + 5.minutes).strftime("%M").to_i
    par[:fq] << "{!cache=false cost=20} #{day}_start:[* TO #{now_time}] AND #{day}_end:[#{now_plus_5min} TO *]"
    #search type
    search_type = nil
    # If Category selected from suggestions
    if result.has_key?("cat_category")
      # logger.debug "CATEGORY"
      # logger.debug result
      par[:q] = "\"#{params[:what]}\"" unless params[:what].nil?
      unless params[:where].nil? or params[:where].empty?
        statecity = params[:where].split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
      par[:wt] = "json"
      # making call to SOLR
      search_type = 1
      response = solr.get 'listings', :params => par
    # If Company is selected from suggestions
    elsif result.has_key?("company")
      # logger.debug "COMPANY"
      # logger.debug result["categories"]
      #par[:phrases] = { :company => params[:what] }
      par[:q] = "company:\"#{params[:what]}\"" unless params[:what].blank?
      if result["categories"]
        #par[:phrases] = { :categories => result["categories"] }
        result["categories"].each do |cat|
           par[:q] << " OR categories:\"#{cat}\""
         end
      end
      # logger.debug par[:q]
      par[:qf] = "company^20 categories^5"
      par[:pf] = "company^20 categories^5"
      unless params[:where].nil? or params[:where].empty?
        statecity = params[:where].split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
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
      par[:wt] = "json"
      search_type = 3
      response = solr.get 'listingsfree', :params => par
    end
    # logger.debug response["response"]["docs"]
    json_response = JSON.parse(response)
    listing_ads = json_response["response"]["docs"]


    # Saving log of Searching
    #Gettings Listings Ids for logging
    ids = []
    listing_ads.each do |listing|
      id = listing.select { |key, value| key.to_s.match(/^id/) }
      ids.push(id)

      # Use dynamic phone
      #
      # Start—Reservation of multiple Numbers
      listing["term_num"], listing["solr_term_num"] = extract_phone_number(listing, mobile_phone: mobile_device?)
      # End--- Reservation of multiple numbers
    end

    # Saving log of Listings
    position = 1    
    attempt = 0
    ## if ads are executed before logging
    begin
      search_id_redis = eval(REDIS.get(cookies[:browse_history_id].to_s+"_search_id"))
    rescue
      search_id_redis = nil
    end
    
    redis_key_ads = cookies[:browse_history_id].to_s+"_search_id_ads".gsub(' ','')
    puts REDIS.set(redis_key_ads,ids.to_json) if search_id_redis.blank?
    ids.each do |pair|
      begin
        puts "begin"
        search_id = search_id_redis
        # It can be removed in the future if no validation of existance in listings table is needed.
        # found = Listing.find(pair["id"])

        found_id = pair["id"]
        unless search_id.blank?
          l = ListingDisplayHistory.create(
            {
              :search_history_id => search_id,
              # :listing_id => found.id,
              :listing_id => found_id,
              :position => position,
              :app_id => cookies[:app_id],
              :ad_flag => 1              
            }
          )
          position = position + 1
          puts l
          # Add listing_display_histories_id to response
          # listing_ads.select{|l| l["id"].to_s == found.id.to_s}[0].merge!({:listing_display_histories_id => l.id})
          listing_ads.select{|l| l["id"].to_s == found_id.to_s}[0].merge!({:listing_display_histories_id => l.id})
        end
        if search_id.blank?
          retrying_the_code
        end
      rescue => e        
        attempt = attempt + 1
        retry if attempt < 3
      end
    end
    REDIS.set(cookies[:browse_history_id].to_s+"_search_id", nil)
    # END LOGGING ************************************************
    respond_with listing_ads
  end

end
