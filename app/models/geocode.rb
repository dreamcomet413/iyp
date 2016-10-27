module Geocode
  class << self
    def geocode_by_ip(ip)
      # TODO: use env config files
      if Rails.env.development?
        to_hash Geokit::Geocoders::GoogleGeocoder.geocode(ip)
      else
        to_hash Geokit::Geocoders::YahooGeocoder.geocode(ip)
      end
    end

    def geocode_by_latlon(args)
      to_hash Geokit::Geocoders::GoogleGeocoder.reverse_geocode("#{args[:lat]},#{args[:lon]}")
    end

    def to_hash(location)
      { country_code: location.country_code, city_and_state: city_and_state(location) }
    end

    def city_and_state(location)
      location.country_code == "US" ? "#{location.city}, #{location.state}" : "Seattle, Wa"
    end
  end
end

