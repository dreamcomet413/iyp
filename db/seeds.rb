if Rails.env == "development"

  50.times do
    l = Listing.create!({
      company: Faker::Company.name,
      cat_1: rand(100),
      cat_1_bak: rand(100),
      lat: Faker::Geolocation.lat,
      lon: Faker::Geolocation.lng,
      term_num:  Faker::PhoneNumber.short_phone_number
    })

    NumMatch.create!({
      term_num: Faker::PhoneNumber.short_phone_number,
      num_display_history_id: rand(100),
      num_type: 3,
      listing_id: rand(100),
      app_id: rand(100),
      expires: [nil, Time.now + 1.day].sample
    })

    BrowseHistory.create!({
      app_id: rand(100),
      ip: Faker::Internet.ip_v4_address,
      referring_url: Faker::Internet.uri("http")
    })
  end
end
