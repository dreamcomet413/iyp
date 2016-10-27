require 'geokit'

class OffersController < ApplicationController  

  respond_to :json
  def show
    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    category_ids = get_category_ids(params[:what], params[:where], location)
    puts category_ids.inspect
    offer = Offer.find_for_popup(category_ids, params[:where], location, cookies[:app_id])
    if offer
      history = OfferHistory.create(app_id: cookies[:app_id], 
                          offer_id: offer.id,
                          browse_history_id: cookies[:browse_history_id])
      offer.assign_fields(cookies[:app_id], request.remote_ip, history.id)
    end
    respond_with offer
  end

  def set_clicked_time
    offer_history = OfferHistory.find(params[:id])
    offer_history.click = Time.zone.now
    offer_history.save
    render nothing: true
  end

  def set_closed_window_time
    offer_history = OfferHistory.find(params[:id])
    offer_history.closed_window = Time.zone.now
    offer_history.save
    render nothing: true
  end

  def latest_num_match
    num_type = mobile_device? ? "4" : params["num_type"]
    match = NumMatch.where(num_type: num_type).order("updated_at ASC").last
    respond_with match
  end

  private
  def get_category_ids(what, where, location)
    query_result = nil

    # Getting previously saved suggestions results if exists    
    begin
      puts "get Json redis #{cookies[:browse_history_id]}"
      results = JSON.parse REDIS.get(cookies[:browse_history_id])
    rescue TypeError
      results = []
    end


    # Getting GEO IP information
    par = {}
    par[:fl] = 'catids'
    par[:pt] = "41.15,73.85"
    unless !location.success and ( location.lng.nil? or location.lat.nil? )
      par[:pt] = "#{location.lat},#{location.lng}"
    end
    # puts geo

    # If exists ?
    result = {}
    # Searching params[:what] text search within suggestions results
    results.each do |suggestion|
      result = suggestion if suggestion.value?(what)
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
      par[:q] = "\"#{what}\"" unless what.blank?
      unless where.nil? or where.empty?
        statecity = where.split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
      search_type = 1
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      # making call to SOLR
      query_result = solr.get 'listings', :params => par
    # If Company is Selected from Suggestions
    elsif result.has_key?("company")
      # logger.debug "COMPANY"
      par[:q] = "company:\"#{what}\"" unless what.blank?
      #par[:phrases] = { :company => params[:what] }
      if result["categories"]
        #par[:phrases] = { :categories => result["categories"] }
         result["categories"].each do |cat|
           par[:q] << " OR categories:\"#{cat}\""
         end
      end
      par[:qf] = "company^20 categories^5"
      par[:pf] = "company^20 categories^5"
      unless where.nil? or where.empty?
        statecity = where.split(',')
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{statecity[1].lstrip}\") OR (service_area:City AND city:\"#{statecity[0]}\" AND state:\"#{statecity[1].lstrip}\") OR (service_area:Zip AND state:\"#{statecity[1].lstrip}\" AND city:\"#{statecity[0]}\")"
      end
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      search_type = 2
      query_result = solr.get 'listings', :params => par
    # if neither a Company nor Category was selected from suggestions (Free text)
    else
      # logger.debug "FREE TEXT"
      par[:q] = "#{what}"
      unless where.nil? or where.empty?
        statecity = where.split(',')
        state_tmp = statecity[1] || "\"\""
        state_tmp = state_tmp.lstrip if state_tmp
        city_tmp = statecity[0] || "\"\""
        par[:fq] << "{!cache=false cost=50} service_area:National OR (service_area:State AND state:\"#{state_tmp}\") OR (service_area:City AND city:\"#{city_tmp}\" AND state:\"#{state_tmp}\") OR (service_area:Zip AND state:\"#{state_tmp}\" AND city:\"#{city_tmp}\")"
      end
      par[:fq] << "-ad_flag:1"
      par[:wt] = "json"
      search_type = 3
      query_result = solr.get 'listingsfree', :params => par
    end
    puts query_result.inspect
    arr = parse_categories(query_result)
    arr
  end

  def parse_categories(result)
    raw_result = JSON.parse(result)["response"]["docs"]
    raw_result.map { |h| h["catids"] }.flatten.uniq
  end

end
