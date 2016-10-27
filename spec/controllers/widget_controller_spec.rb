require 'spec_helper'

describe WidgetController do

  describe "GET 'index'" do
    it "returns http success" do
      request.cookies["cookie_test"] = true
      get 'index'
      response.should be_success
    end
  end

end
