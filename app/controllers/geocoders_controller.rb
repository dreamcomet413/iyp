class GeocodersController < ApplicationController
  respond_to :json

  def city_and_state
    resp = if params[:position]
      session[:location] ||= {}
      session[:location][:lat] = params[:position][:lat]
      session[:location][:lon] = params[:position][:lon]

      Geocode.geocode_by_latlon params[:position].extract!(:lat, :lon)
    else
      [session][:location]
    end

    respond_with({city_and_state: resp}, location: nil)
  end
end

