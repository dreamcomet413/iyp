class SuggestionsController < ApplicationController
  respond_to :json  

  def index
    city, state = get_city_and_state(params[:where])

    categories = solr.get('catsuggest', 
      params: { 
        fq:   "cat_cities\:\"#{params[:where]}\"",
        q:    params[:what],
        rows: params[:maxRows] || 12,
        wt:   "json" 
      }
    )

    companies = solr.get('listingsuggest', 
      params: { 
        q:    "{!prefix f=fsuggestcompany}#{state.lstrip}/#{city}/#{params[:what].downcase}",
        rows: "#{params[:maxRows]}" || 12,
        wt:   "json" 
      }
    )

    categories_array = JSON.parse(categories)["response"]["docs"]
    companies_array  = JSON.parse(companies)["response"]["docs"]

    # Merging results into categories array
    categories_array += companies_array 

    # Saving merged results into Redis
    # Using app_id as key - multiple browsers opened making queries issue has to be solved yet
    puts "listing suggestions redis cookie = #{cookies[:browse_history_id]}"
    puts REDIS.set(cookies[:browse_history_id], categories_array.to_json)

    respond_with categories_array.to_json
  end

  def cities

    #/solr/terms?wt=json&q=seattle&limit=10&terms.prefix=seattle&terms.sort=count&terms.fl=citystate
    #    cities = solr.get 'terms',  :params => { :q => "#{params[:where].downcase}",
    #                                :limit => "#{params[:maxRows]}" || 10,
    #                                "terms.prefix" => "#{params[:where].downcase}",
    #                                "terms.sort" => "count",
    #                                "terms.fl" => "citystate",
    #                                :wt  => "json" }

    # New param below still needs edits
    #/solr/terms?limit=10&terms.regex=seattle.*&terms.regex.flag=
    #case_insensitive&terms.sort=count&terms.fl=citystate&wt=json

    cities = solr.get 'terms',  :params =>{
      #:limit => "#{params[:maxRows] || 10}" ,
      "terms.limit" => "#{params[:maxRows] || 10}" ,
      "terms.regex" => "#{params[:where].downcase + ".*"}",
      "terms.regex.flag" => "case_insensitive",
      "terms.sort" => "count",
      "terms.fl" => "citystate",
      :wt  => "json" }
    require 'pp'

    cities_array = Array.new(JSON.parse(cities)["terms"]["citystate"])
    cities_result = cities_array.select { |value| value.class == String }
    respond_with cities_result
  end 

  protected

  def get_city_and_state(where)
    city  = 'seattle'
    state = 'wa'
    unless where.nil? or where.empty?
      statecity = where.split(',')
      city  = statecity[0].downcase unless statecity[0].blank?
      state = statecity[1].downcase unless statecity[1].blank?
    end
    [city, state]
  end
end
