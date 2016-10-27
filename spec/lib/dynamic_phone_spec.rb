require 'spec_helper'

describe DynamicPhone do
	class FakeController
		include DynamicPhone

		def phone_number(hash, opts = {})
			extract_phone_number(hash, opts)
		end
	end

	subject { FakeController.new }

	it "should return the term_num from solr hash" do
	  solr_hash = {"num_type" => "1", "term_num" => "1234"}
	  term_num = subject.phone_number(solr_hash)	
	  term_num.should == "1234"
	end

	it "should return the alt_phone from solr hash" do
	  solr_hash = {"num_type" => "2", "alt_phone" => "1234"}
	  alt_phone = subject.phone_number(solr_hash)	
	  alt_phone.should == "1234"
	end

	it "should return the oldest record from NumMatch when num_type > 2" do
		oldest = NumMatch.create(num_type: 3, expires: Time.now - 5.minutes, updated_at: 3.hours.ago, display_num: "5678")
		newest = NumMatch.create(num_type: 3, expires: Time.now - 5.minutes, updated_at: 2.hours.ago, display_num: "1234")
	  solr_hash = {"num_type" => "3", "term_num" => "0000"}
	  alt_phone = subject.phone_number(solr_hash)	
	  alt_phone.should == ["5678", "0000"]
	end

	it "should return only num_type=4 when mobile_phone is true" do
		oldest = NumMatch.create(num_type: 4, expires: Time.now - 5.minutes, updated_at: 3.hours.ago, display_num: "5678")
		newest = NumMatch.create(num_type: 4, expires: Time.now - 5.minutes, updated_at: 2.hours.ago, display_num: "1234")
	  solr_hash = {"num_type" => "1", "term_num" => "0000"}
	  alt_phone = subject.phone_number(solr_hash, mobile_phone: true)	
	  alt_phone.should == ["5678", "0000"]
	end
	
end
	
