require 'spec_helper'

describe ListingsController do
  describe "should work with dynamic phone number correctly" do
    it "when num_type is 1" do
      solr_hash = {
        "num_type"  => "1",
        "term_num"  => "206-347-3417"
      }

      listings_controller = ListingsController.new
      listings_controller.instance_exec(solr_hash) do
        extract_phone_number(solr_hash)
      end.should == "206-347-3417"
    end

    it "when num_type is 2" do
      solr_hash = {
        "num_type"   => "2",
        "alt_phone"  => "222-222-2222",
        "term_num"   => "206-347-3417"
      }

      listings_controller = ListingsController.new
      listings_controller.instance_exec(solr_hash) do
        extract_phone_number(solr_hash)
      end.should == "222-222-2222"
    end

    it "when num_type is 3" do
      solr_hash = {
        "num_type"   => "3",
        "term_num"   => "206-347-3417"
      }

      oldest_record = NumMatch.create! display_num: "444-444-4444",
                                       num_display_history_id: "3",
                                       term_num: "206-347-3417",
                                       num_type: "3",
                                       updated_at: 2.days.ago

      NumMatch.create! display_num: "555-555-5555",
                       num_display_history_id: "3",
                       term_num: "123-123-1234",
                       num_type: "3",
                       updated_at: 2.hours.ago

      listings_controller = ListingsController.new
      result = listings_controller.instance_exec(solr_hash) do
        extract_phone_number(solr_hash)
      end
      result.should == ["444-444-4444", "206-347-3417"]
    end
  end

  describe "POST 'update_reserved_number'" do
    before :each do
      request.cookies["cookie_test"] = true
    end

    it "should return the oldest num_match and update expires attribute" do
      match = NumMatch.create(num_type: 3, expires: Time.now - 5.minutes, updated_at: 2.hours.ago, display_num: "1234")
      expires = match.expires
      post :update_reserved_number, num_type: 3, format: :json
      match.reload 
      response.should be_success
      match.expires.should > expires
    end

    it "should return the oldest num_match with num_type=4 and update expires attribute when mobile_phone" do
      request.stub!(:user_agent).and_return("mobile")
      match = NumMatch.create(num_type: 4, expires: Time.now - 5.minutes, updated_at: 2.hours.ago, display_num: "1234")
      expires = match.expires
      post :update_reserved_number, num_type: 3, format: :json
      match.reload 
      response.should be_success
      match.expires.should > expires
    end
  end
end
