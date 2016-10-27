require 'spec_helper'
require 'json'
class FakeGeo < Struct.new(:state, :city, :success)
end

describe Offer do
  it "should find an offer by category and 'National' service_area and 0 for cat_1" do
    subject = Offer.create(active: true, cat_1: 1, service_area: 'National')
    offer = Offer.find_for_popup([1], "", mock(success: false))
    offer.should == subject
  end

  it "should find an offer by category and 'National' service_area" do
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National')
    offer = Offer.find_for_popup([2], "", mock(success: false))
    offer.should == subject
  end

  it "should find an offer by category and 'Zip' service_area" do
    location = FakeGeo.new("state", "city", true)
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'Zip', state: "state", city: "city")
    offer = Offer.find_for_popup([2], "", location)
    offer.should == subject
  end

  it "should find an offer by category and 'City' service_area" do
    location = FakeGeo.new("state", "city", true)
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'City', state: "state", city: "city")
    offer = Offer.find_for_popup([2], "", location)
    offer.should == subject
  end

  it "should find an offer by category and 'State' service_area" do
    location = FakeGeo.new("MyState", "nobody_cares", true)
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'State', state: "MyState")
    offer = Offer.find_for_popup([2], "", location)
    offer.should == subject
  end

  it "should find the olderst updated_at record" do
    subject1 = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National', updated_at: 3.months.ago)
    subject2 = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National', updated_at: 4.months.ago)
    subject3 = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National', updated_at: 2.months.ago)
    offer = Offer.find_for_popup([2], "", mock(success: false))
    offer.should == subject2
  end

  it "should find an offer by category and 'National' service_area and gender" do
    user = User.create(salutation: "Mr", role_id: 1)
    app = App.create(user_id: user.id)
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National', gender: "Mr")
    OfferHistory.create(app_id: app.id, offer_id: subject.id, created_at: 40.days.ago)
    offer = Offer.find_for_popup([2], "", mock(success: false), app.id)
    offer.should == subject
  end

  it "should find an offer by category and 'National' service_area and gender when the offer gender is nil"     do
    user = User.create(salutation: "Mr", role_id: 1)
    app = App.create(user_id: user.id)
    subject = Offer.create(active: true, cat_2: 2, service_area: 'National', gender: nil)
    OfferHistory.create(app_id: app.id, offer_id: subject.id, created_at: 35.days.ago)
    offer = Offer.find_for_popup([2], "", mock(success: false), app.id)
    offer.should == subject
  end


  it "should not find that offer with less than 30 day offer_history" do
    user = User.create(salutation: "Mr", role_id: 1)
    app = App.create(user_id: user.id)
    subject = Offer.create(active: true, cat_1: 1, cat_2: 2, service_area: 'National', gender: "Mr")
    OfferHistory.create(app_id: app.id, offer_id: subject.id, created_at: 25.days.ago)
    offer = Offer.find_for_popup([2], "", mock(success: false), app.id)
    offer.should == nil
  end

  it "should find an offer by category and 'National' service_area and within the given time range" do
    time = Time.new(2013,1,3,12,0,0).in_time_zone(Time.zone)
    subject = Offer.create(active: true, 
                           cat_1: 1, 
                           cat_2: 2, 
                           service_area: 'National',
                           mon_start: 480, 
                           mon_end: 960, 
                           tue_start: 480, 
                           tue_end: 960
                           )

    Time.stub_chain(:zone, :now) { time }
    offer = Offer.find_for_popup([2], "", mock(success: false))
    Time.rspec_reset
    offer.should == subject
  end

  it "should not find an offer by category and 'National' service_area and within the given time range" do
    time = Time.new(2013,1,3,2,0,0).in_time_zone(Time.zone)
    subject = Offer.create(active: true, 
                           cat_1: 1, 
                           cat_2: 2, 
                           service_area: 'National',
                           thu_start: 480, 
                           thu_end: 960
                           )

    Time.stub_chain(:zone, :now) { time }
    offer = Offer.find_for_popup([2], "", mock(success: false))
    Time.rspec_reset
    offer.should == nil
  end

  it "should get the display num from the oldest num_match when num type > 2 and display_type = 2" do
    NumMatch.create(display_num: "1111111111", num_type: 3, updated_at: 2.days.ago)
    NumMatch.create(display_num: "2222222222", num_type: 3, updated_at: 3.days.ago)
    user = User.create(salutation: "Mr", role_id: 1)
    app = App.create(user_id: user.id)
    subject = Offer.create(active: true, 
                           cat_1: 1,
                           cat_2: 2, 
                           gender: "Mr",
                           service_area: 'National',
                           display_type: 2,
                           num_type: 3
                           )

    offer = Offer.find_for_popup([2], "", mock(success: false), app.id)
    offer.should == subject
    offer.assign_fields(app.id, "10.10.10.10", 11)
    offer.as_json[:phone_number_from_num_matches].should == "1111111111"
    num = NumMatch.find("1111111111")
    num.app_id.should == app.id
    num.offer_id.should == offer.id
    num.term_num.should == offer.term_num
    num.ip == "10.10.10.10"
      
  end

end
