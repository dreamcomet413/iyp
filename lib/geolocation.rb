class GeoLocation
	DEFAULT_LOCATION = "41.15,73.85"

	def self.get_location(ip, geolocation_param)
		return geolocation_param unless geolocation_param.blank?
    location = DEFAULT_LOCATION
		geo = Geokit::Geocoders::MultiGeocoder.geocode(ip)
    if self.geo_success? geo
      location = "#{geo.lat},#{geo.lng}"
    end
    location
	end

	private

	def self.geo_success?(geo)
		geo.success and (geo.lng or geo.lat)
	end
end