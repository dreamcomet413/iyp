module DynamicPhone

  protected

  def extract_phone_number(solr_hash, opts = {})
    return handle_mobile_phone(solr_hash) if opts[:mobile_phone]

    case solr_hash["num_type"]
    when "1"
      solr_hash["term_num"]
    when "2"
      solr_hash["alt_phone"]
    else
      handle_num_type_more_than_3!(solr_hash)
    end
  end

  def handle_mobile_phone(solr_hash)
    params = {"num_type" => "4", "term_num" => solr_hash["term_num"]}
    handle_num_type_more_than_3!(params)
  end

  def handle_num_type_more_than_3!(solr_hash, return_object = false)
    if oldest_record = NumMatch.oldest_for(num_type: solr_hash["num_type"])
      oldest_record.update_attribute :expires, Time.now + 1.minutes
      if return_object
        [oldest_record.display_num, solr_hash["term_num"], oldest_record]
      else
        [oldest_record.display_num, solr_hash["term_num"]]
      end
    else
      # solr_hash["term_num"]
      nil
    end
  end
end
