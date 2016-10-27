require 'spec_helper'

describe ListingsController do
  describe "should restrict access based on user geolocation" do
    it "should restrict access from all countries except USA and Canada" do
      application_controller = ApplicationController.new
      ip_DE = "1.1.1.1"
      ip_US = "38.105.71.43"
      ip_CA = "99.243.198.12"
      ip_BR = "189.15.185.113"
      ip_IT = "95.74.195.44"

      Widget::Application.config.stub(:restrict_access_from_all_countries_except_USA_and_Canada).and_return(true)

      application_controller.instance_exec() do
        blocked_ip(ip_DE)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_BR)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_IT)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_US)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_CA)
      end.should == false
    end
    
    it "should not restrict access from all countries except USA and Canada" do
      application_controller = ApplicationController.new
      ip_DE = "1.1.1.1"
      ip_US = "38.105.71.43"
      ip_CA = "99.243.198.12"
      ip_BR = "189.15.185.113"
      ip_IT = "95.74.195.44"

      Widget::Application.config.stub(:restrict_access_from_all_countries_except_USA_and_Canada).and_return(false)

      application_controller.instance_exec() do
        blocked_ip(ip_DE)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_BR)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_IT)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_US)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_CA)
      end.should == false
    end

    it "should allow access only from" do
      application_controller = ApplicationController.new
      ip_DE = "1.1.1.1"
      ip_US = "38.105.71.43"
      ip_CA = "99.243.198.12"
      ip_BR = "189.15.185.113"
      ip_IT = "95.74.195.44"

      Widget::Application.config.stub(:allow_access_only_from).and_return(["US", "CA", "DE"])

      application_controller.instance_exec() do
        blocked_ip(ip_DE)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_BR)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_IT)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_US)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_CA)
      end.should == false
    end

    it "should restrict access only from" do
      application_controller = ApplicationController.new
      ip_DE = "1.1.1.1"
      ip_US = "38.105.71.43"
      ip_CA = "99.243.198.12"
      ip_BR = "189.15.185.113"
      ip_IT = "95.74.195.44"

      Widget::Application.config.stub(:restrict_access_only_from).and_return(["US", "CA"])

      application_controller.instance_exec() do
        blocked_ip(ip_DE)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_BR)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_IT)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_US)
      end.should == true

      application_controller.instance_exec() do
        blocked_ip(ip_CA)
      end.should == true
    end

    it "should allow access is related config wasn't specified" do
      application_controller = ApplicationController.new
      ip_DE = "1.1.1.1"
      ip_US = "38.105.71.43"
      ip_CA = "99.243.198.12"
      ip_BR = "189.15.185.113"
      ip_IT = "95.74.195.44"

      application_controller.instance_exec() do
        blocked_ip(ip_DE)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_BR)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_IT)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_US)
      end.should == false

      application_controller.instance_exec() do
        blocked_ip(ip_CA)
      end.should == false
    end
  end
end
