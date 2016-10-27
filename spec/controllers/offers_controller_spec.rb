require 'spec_helper'

describe OffersController do
  before :each do
    request.cookies["cookie_test"] = true
  end

  it "PUT 'set_clicked_time'" do
    oh = OfferHistory.create(click: nil)
    put :set_clicked_time, id: oh.id
    oh.reload
    oh.click.should_not be_nil
  end

  it "PUT 'set_closed_window_time'" do
    oh = OfferHistory.create(closed_window: nil)
    put :set_closed_window_time, id: oh.id
    oh.reload
    oh.closed_window.should_not be_nil
  end
end
