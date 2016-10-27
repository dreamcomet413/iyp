require 'spec_helper'

describe GeoLocation do
	context "no geolocation param given" do 
		it "unsuccessful GeoKit lookup" do
			geo = stub(:geo, success: false, lng: nil, lat: nil)
			Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).with("ip") { geo }
			GeoLocation.get_location("ip", "").should == GeoLocation::DEFAULT_LOCATION
		end

		it "successfull GeoKit lookup" do
			geo = stub(:geo, success: true, lng: "1.1", lat: "2.2")
			Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).with("ip") { geo }
			GeoLocation.get_location("ip", "").should == "2.2,1.1"
		end
	end

	it "returns the given geolocation param" do
		GeoLocation.get_location("ip", "5.5,6.6").should == "5.5,6.6"
	end
end
	
