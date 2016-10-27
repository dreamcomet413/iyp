# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "abuses", :force => true do |t|
    t.timestamp "created_at"
    t.integer   "app_id"
    t.string    "ip",           :limit => 45
    t.string    "caller_id",    :limit => 45
    t.integer   "searches",     :limit => 2
    t.integer   "num_displays", :limit => 2
    t.integer   "calls",        :limit => 2
    t.integer   "clicks"
    t.integer   "click_dur",    :limit => 1
    t.integer   "call_dur",     :limit => 1
    t.integer   "user_id"
  end

  create_table "ad_spends", :force => true do |t|
    t.string   "ad_id",              :limit => 45
    t.integer  "total_calls"
    t.integer  "total_paid"
    t.integer  "total_unpaid"
    t.integer  "ytd"
    t.integer  "paid_ytd"
    t.integer  "unpaid_ytd"
    t.integer  "yesterday"
    t.integer  "paid_yesterday"
    t.integer  "unpaid_yesterday"
    t.integer  "7_days"
    t.integer  "paid_7_days"
    t.integer  "unpaid_7_days"
    t.integer  "this_month"
    t.integer  "paid_this_month"
    t.integer  "unpaid_this_month"
    t.integer  "last_month"
    t.integer  "paid_last_month"
    t.integer  "unpaid_last_month"
    t.integer  "current_prepayment"
    t.integer  "cap_used"
    t.integer  "budget_remaining"
    t.datetime "updated_at"
  end

  create_table "advertiser_charges", :primary_key => "idadvertiser_charges", :force => true do |t|
  end

  create_table "advertiser_payments", :force => true do |t|
    t.decimal   "amount",     :precision => 12, :scale => 2, :null => false
    t.integer   "user_id"
    t.timestamp "created_at"
  end

  create_table "aggregation_execution_logs", :force => true do |t|
    t.string   "name"
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  create_table "app_histories", :force => true do |t|
    t.integer   "app_id"
    t.integer   "calls_total",     :default => 0
    t.integer   "calls_last_yr",   :default => 0
    t.integer   "calls_last_qtr",  :default => 0
    t.integer   "calls_last_7",    :default => 0
    t.integer   "calls_yesterday", :default => 0
    t.integer   "calls_ytd",       :default => 0
    t.integer   "calls_qtd",       :default => 0
    t.integer   "calls_mtd",       :default => 0
    t.integer   "calls_jan",       :default => 0
    t.integer   "calls_feb",       :default => 0
    t.integer   "calls_mar",       :default => 0
    t.integer   "calls_apr",       :default => 0
    t.integer   "calls_may",       :default => 0
    t.integer   "calls_jun",       :default => 0
    t.integer   "calls_jul",       :default => 0
    t.integer   "calls_aug",       :default => 0
    t.integer   "calls_sep",       :default => 0
    t.integer   "calls_oct",       :default => 0
    t.integer   "calls_nov",       :default => 0
    t.integer   "calls_dec",       :default => 0
    t.datetime  "created_at",                     :null => false
    t.timestamp "updated_at",                     :null => false
    t.integer   "calls_last_mos"
  end

  create_table "apps", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",        :limit => 45
    t.string   "platform_id", :limit => 45
    t.datetime "created_at"
    t.date     "deleted_at"
  end

  create_table "browse_histories", :force => true do |t|
    t.integer   "app_id"
    t.timestamp "created_at"
    t.string    "ip",            :limit => 45
    t.string    "referring_url", :limit => 100
    t.string    "os",            :limit => 50
    t.string    "browser",       :limit => 50
    t.string    "device",        :limit => 50
  end

  create_table "call_histories", :force => true do |t|
    t.datetime  "created_at"
    t.string    "display_num",            :limit => 100
    t.string    "caller_id",              :limit => 100
    t.datetime  "start_time"
    t.datetime  "end_time"
    t.integer   "duration",               :limit => 3
    t.decimal   "price",                                  :precision => 10, :scale => 4
    t.string    "direction",              :limit => 30
    t.string    "answered_by",            :limit => 10
    t.string    "forwarded_from",         :limit => 16
    t.string    "caller_name",            :limit => 200
    t.string    "uri",                    :limit => 1024
    t.string    "from_city",              :limit => 100
    t.string    "from_state",             :limit => 100
    t.string    "account_id",             :limit => 34
    t.string    "call_status",            :limit => 30
    t.string    "from_zip",               :limit => 30
    t.string    "from_country",           :limit => 30
    t.timestamp "updated_at",                                                            :null => false
    t.string    "parent_call_sid",        :limit => 34
    t.string    "term_num",               :limit => 100
    t.string    "recording_uri",          :limit => 1024
    t.integer   "listing_id"
    t.string    "keypress",               :limit => 100
    t.integer   "num_display_history_id"
    t.integer   "app_id"
    t.string    "ip",                     :limit => 60
  end

  add_index "call_histories", ["account_id"], :name => "account_id"

  create_table "call_revs", :primary_key => "This week", :force => true do |t|
  end

  create_table "call_timelimits", :id => false, :force => true do |t|
    t.string   "id",           :limit => 34,  :null => false
    t.datetime "trigger_time",                :null => false
    t.string   "redirect_to",  :limit => 512, :null => false
  end

  create_table "cat_by_city", :id => false, :force => true do |t|
    t.string  "city_state", :limit => 60, :null => false
    t.integer "cat",        :limit => 2
  end

  add_index "cat_by_city", ["cat"], :name => "cat_index"
  add_index "cat_by_city", ["city_state"], :name => "city_index"

  create_table "charges", :force => true do |t|
    t.string    "user_id",             :limit => 45
    t.integer   "PaymentMethodTypeId",                                               :null => false
    t.string    "PaymentMethodType",   :limit => 16,                                 :null => false
    t.decimal   "amount",                             :precision => 12, :scale => 5, :null => false
    t.string    "Result",              :limit => 45,                                 :null => false
    t.string    "CreditCardId",        :limit => 36,                                 :null => false
    t.string    "PaymentEmail",        :limit => 248,                                :null => false
    t.timestamp "created_at",                                                        :null => false
  end

  add_index "charges", ["CreditCardId"], :name => "CreditCardId"
  add_index "charges", ["CreditCardId"], :name => "fk_chargecreditcard"

  create_table "click_histories", :force => true do |t|
    t.string    "platform",   :limit => 45
    t.timestamp "created_at"
  end

  create_table "countries", :force => true do |t|
    t.string  "A2",               :limit => 2, :null => false
    t.string  "Name",                          :null => false
    t.integer "Numeric",                       :null => false
    t.string  "CountryPhoneCode", :limit => 5, :null => false
    t.boolean "Enabled",                       :null => false
  end

  create_table "creditcards", :force => true do |t|
    t.string  "CardType",       :limit => 16,  :null => false
    t.string  "NameOnCard",                    :null => false
    t.string  "NumberCrypt",    :limit => 128, :null => false
    t.integer "CreditCardType",                :null => false
    t.string  "ExpirationDate", :limit => 32,  :null => false
    t.string  "AddressId",      :limit => 36,  :null => false
    t.string  "CvNumberCrypt",  :limit => 64,  :null => false
    t.string  "UserNote",       :limit => 128, :null => false
  end

  create_table "creditcardtypes", :primary_key => "Id", :force => true do |t|
    t.string "Name",        :limit => 45
    t.text   "Description"
  end

  create_table "generation_calls_earnings", :force => true do |t|
    t.integer  "user_id",                                                            :null => false
    t.integer  "generation",                                                         :null => false
    t.integer  "calls_yesterday",                                   :default => 0
    t.integer  "calls_last_7",                                      :default => 0
    t.integer  "calls_mtd",                                         :default => 0
    t.integer  "calls_last_mos",                                    :default => 0
    t.integer  "calls_qtd",                                         :default => 0
    t.integer  "calls_last_qtr",                                    :default => 0
    t.integer  "calls_ytd",                                         :default => 0
    t.integer  "calls_last_yr",                                     :default => 0
    t.integer  "calls_total",                                       :default => 0
    t.integer  "calls_jan",                                         :default => 0
    t.integer  "calls_feb",                                         :default => 0
    t.integer  "calls_mar",                                         :default => 0
    t.integer  "calls_apr",                                         :default => 0
    t.integer  "calls_may",                                         :default => 0
    t.integer  "calls_jun",                                         :default => 0
    t.integer  "calls_jul",                                         :default => 0
    t.integer  "calls_aug",                                         :default => 0
    t.integer  "calls_sep",                                         :default => 0
    t.integer  "calls_oct",                                         :default => 0
    t.integer  "calls_nov",                                         :default => 0
    t.integer  "calls_dec",                                         :default => 0
    t.decimal  "earnings_yesterday", :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_7",    :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_mtd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_mos",  :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_qtd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_qtr",  :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_ytd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_yr",   :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_total",     :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jan",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_feb",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_mar",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_apr",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_may",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jun",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jul",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_aug",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_sep",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_oct",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_nov",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_dec",       :precision => 10, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  add_index "generation_calls_earnings", ["generation"], :name => "generation_index"
  add_index "generation_calls_earnings", ["user_id"], :name => "user_generation_earnings_fk_users"

  create_table "improve_listings", :force => true do |t|
    t.integer   "listing_id",                         :null => false
    t.integer   "term_num_nis", :limit => 1
    t.text      "comment",      :limit => 2147483647
    t.timestamp "created_at",                         :null => false
  end

  create_table "listing_display_histories", :force => true do |t|
    t.integer   "search_history_id"
    t.integer   "listing_id"
    t.integer   "position",          :limit => 1, :null => false
    t.timestamp "created_at",                     :null => false
    t.boolean   "ad_flag"
    t.integer   "app_id"
  end

  add_index "listing_display_histories", ["search_history_id"], :name => "search_hist_id"

  create_table "listings", :force => true do |t|
    t.integer   "user_id",                           :default => 1
    t.string    "company",            :limit => 45,                      :null => false
    t.string    "term_num",           :limit => 25,                      :null => false
    t.string    "alt_phone",          :limit => 25
    t.boolean   "num_type",                          :default => false
    t.string    "address1",           :limit => 45
    t.string    "city",               :limit => 45
    t.string    "state",              :limit => 45
    t.string    "zip",                :limit => 45
    t.string    "country",            :limit => 45
    t.string    "county",             :limit => 45
    t.string    "sic",                :limit => 45
    t.integer   "cat_1",              :limit => 2,                       :null => false
    t.integer   "cat_2",              :limit => 2
    t.integer   "cat_3",              :limit => 2
    t.integer   "cat_4",              :limit => 2
    t.integer   "ad_value",           :limit => 1
    t.integer   "min_dur",            :limit => 2
    t.integer   "repeat_days",        :limit => 1
    t.date      "created_at"
    t.date      "expiry"
    t.integer   "employees"
    t.integer   "years_in_bus",       :limit => 1
    t.string    "logo_url",           :limit => 100
    t.integer   "service_area_range", :limit => 1
    t.string    "service_area",       :limit => 8,   :default => "City"
    t.boolean   "show_address"
    t.integer   "mon_start",          :limit => 2,   :default => -10000
    t.integer   "mon_end",            :limit => 2,   :default => 10000
    t.integer   "tue_start",          :limit => 2,   :default => -10000
    t.integer   "tue_end",            :limit => 2,   :default => 10000
    t.integer   "wed_start",          :limit => 2,   :default => -10000
    t.integer   "wed_end",            :limit => 2,   :default => 10000
    t.integer   "thu_start",          :limit => 2,   :default => -10000
    t.integer   "thu_end",            :limit => 2,   :default => 10000
    t.integer   "fri_start",          :limit => 2,   :default => -10000
    t.integer   "fri_end",            :limit => 2,   :default => 10000
    t.integer   "sat_start",          :limit => 2,   :default => -10000
    t.integer   "sat_end",            :limit => 2,   :default => 10000
    t.integer   "sun_start",          :limit => 2,   :default => -10000
    t.integer   "sun_end",            :limit => 2,   :default => 10000
    t.integer   "ad_budget"
    t.boolean   "active"
    t.integer   "budget_period",      :limit => 1
    t.boolean   "budget_source"
    t.date      "deleted"
    t.timestamp "updated_at"
    t.string    "ext_id",             :limit => 45
    t.string    "slogan",             :limit => 100
    t.string    "lon",                :limit => 45,                      :null => false
    t.string    "lat",                :limit => 45,                      :null => false
    t.string    "url",                :limit => 45
    t.string    "fax",                :limit => 45
    t.string    "headline",           :limit => 35
    t.string    "body_text_1",        :limit => 35
    t.string    "body_text_2",        :limit => 35
    t.boolean   "ad_flag"
  end

  create_table "listings-full", :force => true do |t|
    t.integer   "user_id",                           :default => 1
    t.string    "company",            :limit => 45,                      :null => false
    t.string    "term_num",           :limit => 25,                      :null => false
    t.string    "alt_phone",          :limit => 25
    t.boolean   "num_type",                          :default => false
    t.string    "address1",           :limit => 45
    t.string    "city",               :limit => 45
    t.string    "state",              :limit => 45
    t.string    "zip",                :limit => 45
    t.string    "country",            :limit => 45
    t.string    "county",             :limit => 45
    t.string    "sic",                :limit => 45
    t.integer   "cat_1",              :limit => 2,                       :null => false
    t.integer   "new_cat",            :limit => 2
    t.integer   "cat_1_bak",          :limit => 2,                       :null => false
    t.integer   "cat_2",              :limit => 2
    t.integer   "cat_3",              :limit => 2
    t.integer   "cat_4",              :limit => 2
    t.integer   "ad_value",           :limit => 1
    t.integer   "min_dur",            :limit => 2
    t.integer   "repeat_days",        :limit => 1
    t.date      "created_at"
    t.date      "expiry"
    t.integer   "employees"
    t.integer   "years_in_bus",       :limit => 1
    t.string    "logo_url",           :limit => 100
    t.integer   "service_area_range", :limit => 1
    t.string    "service_area",       :limit => 8,   :default => "City"
    t.boolean   "show_address"
    t.integer   "mon_start",          :limit => 2,   :default => -10000
    t.integer   "mon_end",            :limit => 2,   :default => 10000
    t.integer   "tue_start",          :limit => 2,   :default => -10000
    t.integer   "tue_end",            :limit => 2,   :default => 10000
    t.integer   "wed_start",          :limit => 2,   :default => -10000
    t.integer   "wed_end",            :limit => 2,   :default => 10000
    t.integer   "thu_start",          :limit => 2,   :default => -10000
    t.integer   "thu_end",            :limit => 2,   :default => 10000
    t.integer   "fri_start",          :limit => 2,   :default => -10000
    t.integer   "fri_end",            :limit => 2,   :default => 10000
    t.integer   "sat_start",          :limit => 2,   :default => -10000
    t.integer   "sat_end",            :limit => 2,   :default => 10000
    t.integer   "sun_start",          :limit => 2,   :default => -10000
    t.integer   "sun_end",            :limit => 2,   :default => 10000
    t.integer   "ad_budget"
    t.boolean   "active"
    t.integer   "budget_period",      :limit => 1
    t.boolean   "budget_source"
    t.date      "deleted"
    t.timestamp "updated_at"
    t.string    "ext_id",             :limit => 45
    t.string    "slogan",             :limit => 75
    t.string    "lon",                :limit => 45,                      :null => false
    t.string    "lat",                :limit => 45,                      :null => false
    t.string    "url",                :limit => 45
    t.string    "fax",                :limit => 45
    t.string    "headline",           :limit => 35
    t.string    "body_text_1",        :limit => 35
    t.string    "body_text_2",        :limit => 35
    t.boolean   "ad_flag"
  end

  add_index "listings-full", ["cat_1"], :name => "cat_1"

  create_table "login_histories", :force => true do |t|
    t.integer  "user_id"
    t.datetime "login"
    t.datetime "logout"
  end

  add_index "login_histories", ["user_id"], :name => "login_histories_fk_users"

  create_table "num_display_histories", :force => true do |t|
    t.integer   "listing_display_history_id"
    t.integer   "listing_id"
    t.integer   "app_id"
    t.timestamp "created_at"
    t.string    "ip",                         :limit => 45
  end

  create_table "num_matches", :id => false, :force => true do |t|
    t.string    "display_num", :limit => 45
    t.string    "term_num",               :limit => 45
    t.integer   "num_display_history_id"
    t.timestamp "updated_at"
    t.integer   "num_type",                             :default => 3
    t.integer   "listing_id"
    t.integer   "app_id"
    t.datetime  "expires"
    t.string    "ip",                     :limit => 60
    t.integer   "offer_id",               :limit => 2
    t.boolean   "offer_status"
    t.integer   "offer_value",            :limit => 2
    t.integer   "ad_track",               :limit => 2
  end
  execute "ALTER TABLE num_matches ADD PRIMARY KEY (display_num);"

  create_table "offer_histories", :force => true do |t|
    t.integer   "app_id"
    t.integer   "browse_history_id"
    t.integer   "offer_id"
    t.timestamp "created_at"
    t.datetime  "closed_window"
    t.datetime  "click"
    t.datetime  "num_click"
    t.integer   "num_display_history_id"
  end

  create_table "offers", :force => true do |t|
    t.integer   "display_type",       :limit => 2
    t.string    "headline",           :limit => 35
    t.string    "body_text_1",        :limit => 35
    t.string    "body_text_2",        :limit => 35
    t.boolean   "ad_flag"
    t.string    "iframe_url",         :limit => 150
    t.string    "iframe_headline",    :limit => 75
    t.string    "ad_graphic_link",    :limit => 150
    t.string    "ad_graphic_url",     :limit => 150
    t.string    "embed_code",         :limit => 300
    t.integer   "user_id"
    t.string    "company",            :limit => 45
    t.string    "term_num",           :limit => 25
    t.string    "alt_phone",          :limit => 25
    t.integer   "num_type",           :limit => 2,   :default => 3
    t.string    "address1",           :limit => 45
    t.string    "city",               :limit => 45
    t.string    "state",              :limit => 45
    t.string    "zip",                :limit => 45
    t.string    "country",            :limit => 45
    t.string    "county",             :limit => 45
    t.string    "sic",                :limit => 45
    t.integer   "cat_1",              :limit => 2
    t.integer   "cat_2",              :limit => 2
    t.integer   "cat_3",              :limit => 2
    t.integer   "cat_4",              :limit => 2
    t.integer   "ad_value",           :limit => 1
    t.integer   "min_dur",            :limit => 2
    t.integer   "repeat_days",        :limit => 1
    t.timestamp "created_at",                                            :null => false
    t.date      "expiry"
    t.integer   "employees"
    t.integer   "years_in_bus",       :limit => 1
    t.string    "logo_url",           :limit => 100
    t.integer   "service_area_range", :limit => 1
    t.string    "service_area",       :limit => 8,   :default => "City"
    t.boolean   "show_address"
    t.integer   "mon_start",          :limit => 2,   :default => -10000
    t.integer   "mon_end",            :limit => 2,   :default => 10000
    t.integer   "tue_start",          :limit => 2,   :default => -10000
    t.integer   "tue_end",            :limit => 2,   :default => 10000
    t.integer   "wed_start",          :limit => 2,   :default => -10000
    t.integer   "wed_end",            :limit => 2,   :default => 10000
    t.integer   "thu_start",          :limit => 2,   :default => -10000
    t.integer   "thu_end",            :limit => 2,   :default => 10000
    t.integer   "fri_start",          :limit => 2,   :default => -10000
    t.integer   "fri_end",            :limit => 2,   :default => 10000
    t.integer   "sat_start",          :limit => 2,   :default => -10000
    t.integer   "sat_end",            :limit => 2,   :default => 10000
    t.integer   "sun_start",          :limit => 2,   :default => -10000
    t.integer   "sun_end",            :limit => 2,   :default => 10000
    t.integer   "ad_budget"
    t.boolean   "active"
    t.integer   "budget_period",      :limit => 1
    t.boolean   "budget_source"
    t.date      "deleted"
    t.datetime  "updated_at"
    t.string    "ext_id",             :limit => 45
    t.string    "slogan",             :limit => 75
    t.string    "lon",                :limit => 45
    t.string    "lat",                :limit => 45
    t.string    "url",                :limit => 45
    t.string    "fax",                :limit => 45
    t.string    "gender",             :limit => 12
  end

  add_index "offers", ["cat_1"], :name => "cat_1"
  add_index "offers", ["user_id"], :name => "offers_fk_users"

  create_table "payment_histories", :force => true do |t|
    t.string    "user_id",        :limit => 45
    t.decimal   "amount",                       :precision => 8, :scale => 2
    t.timestamp "created_at"
    t.string    "method",         :limit => 45
    t.string    "transaction_id"
  end

  create_table "payment_method_types", :force => true do |t|
    t.string "type",        :limit => 16, :null => false
    t.string "name",        :limit => 45, :null => false
    t.text   "description",               :null => false
  end

  create_table "platforms", :force => true do |t|
    t.string "platform", :limit => 45, :null => false
  end

  create_table "roles", :force => true do |t|
    t.string "role",        :limit => 32
    t.string "description"
  end

  create_table "scripts", :force => true do |t|
    t.string "name",      :limit => 45
    t.string "script",    :limit => 1000
    t.string "reference", :limit => 45
  end

  create_table "search_histories", :force => true do |t|
    t.integer   "browse_history_id"
    t.string    "refering_URL",      :limit => 45
    t.string    "keywords",          :limit => 45
    t.string    "geo",               :limit => 45
    t.timestamp "created_at"
    t.integer   "app_id"
    t.string    "ip",                :limit => 45
    t.integer   "search_type"
  end

  create_table "specific_categories", :force => true do |t|
    t.string    "specific_category", :limit => 200,                               :null => false
    t.string    "synonym",           :limit => 250
    t.integer   "count"
    t.timestamp "updated_at",                                                     :null => false
    t.date      "deleted"
    t.integer   "sub_category_id"
    t.decimal   "min_bid",                          :precision => 4, :scale => 2
    t.integer   "sic"
    t.boolean   "dups"
    t.boolean   "almost_dups"
    t.boolean   "surviving"
  end

  add_index "specific_categories", ["specific_category"], :name => "specific_category"

  create_table "states", :force => true do |t|
    t.string  "state",                :limit => 100, :null => false
    t.string  "country_id",           :limit => 3,   :null => false
    t.string  "Postal_Abbrev",        :limit => 10,  :null => false
    t.integer "Minimum_Postal_Code",                 :null => false
    t.integer "Maximum_ Postal_Code",                :null => false
  end

  create_table "sub_categories", :force => true do |t|
    t.string "sub_category", :limit => 100, :null => false
  end

  create_table "support", :primary_key => "Id", :force => true do |t|
    t.string  "AccountId",    :limit => 36,                                 :null => false
    t.string  "UserId",       :limit => 36,                                 :null => false
    t.decimal "DateTime",                    :precision => 12, :scale => 0, :null => false
    t.integer "TicketNumber",                                               :null => false
    t.string  "Name",         :limit => 64,                                 :null => false
    t.string  "Email",        :limit => 40,                                 :null => false
    t.string  "Issue",        :limit => 500,                                :null => false
    t.string  "ThreadId",     :limit => 36,                                 :null => false
  end

  create_table "telephony_providers", :force => true do |t|
    t.string "provider", :limit => 126, :null => false
    t.float  "Charge",                  :null => false
  end

  create_table "user_calls_earnings", :force => true do |t|
    t.integer  "user_id",                                                            :null => false
    t.integer  "calls_yesterday",                                   :default => 0
    t.integer  "calls_last_7",                                      :default => 0
    t.integer  "calls_mtd",                                         :default => 0
    t.integer  "calls_last_mos",                                    :default => 0
    t.integer  "calls_qtd",                                         :default => 0
    t.integer  "calls_last_qtr",                                    :default => 0
    t.integer  "calls_ytd",                                         :default => 0
    t.integer  "calls_last_yr",                                     :default => 0
    t.integer  "calls_total",                                       :default => 0
    t.integer  "calls_jan",                                         :default => 0
    t.integer  "calls_feb",                                         :default => 0
    t.integer  "calls_mar",                                         :default => 0
    t.integer  "calls_apr",                                         :default => 0
    t.integer  "calls_may",                                         :default => 0
    t.integer  "calls_jun",                                         :default => 0
    t.integer  "calls_jul",                                         :default => 0
    t.integer  "calls_aug",                                         :default => 0
    t.integer  "calls_sep",                                         :default => 0
    t.integer  "calls_oct",                                         :default => 0
    t.integer  "calls_nov",                                         :default => 0
    t.integer  "calls_dec",                                         :default => 0
    t.decimal  "earnings_yesterday", :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_7",    :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_mtd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_mos",  :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_qtd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_qtr",  :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_ytd",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_last_yr",   :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_total",     :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jan",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_feb",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_mar",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_apr",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_may",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jun",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_jul",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_aug",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_sep",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_oct",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_nov",       :precision => 10, :scale => 4, :default => 0.0
    t.decimal  "earnings_dec",       :precision => 10, :scale => 4, :default => 0.0
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
  end

  add_index "user_calls_earnings", ["user_id"], :name => "user_calls_earnings_fk_users"

  create_table "user_counts", :primary_key => "user_id", :force => true do |t|
    t.integer  "level_1"
    t.integer  "level_2"
    t.integer  "level_3"
    t.integer  "level_4"
    t.integer  "level_5"
    t.integer  "level_6"
    t.integer  "level_7"
    t.integer  "level_8"
    t.integer  "total"
    t.datetime "updated_at"
  end

  create_table "user_histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "calls_total",                                      :default => 0
    t.integer  "calls_last_yr",                                    :default => 0
    t.integer  "calls_last_qtr",                                   :default => 0
    t.integer  "calls_last_mos",                                   :default => 0
    t.integer  "calls_last_7",                                     :default => 0
    t.integer  "calls_yesterday",                                  :default => 0
    t.integer  "calls_ytd",                                        :default => 0
    t.integer  "calls_qtd",                                        :default => 0
    t.integer  "calls_mtd",                                        :default => 0
    t.integer  "calls_jan",                                        :default => 0
    t.integer  "calls_feb",                                        :default => 0
    t.integer  "calls_mar",                                        :default => 0
    t.integer  "calls_apr",                                        :default => 0
    t.integer  "calls_may",                                        :default => 0
    t.integer  "calls_jun",                                        :default => 0
    t.integer  "calls_jul",                                        :default => 0
    t.integer  "calls_aug",                                        :default => 0
    t.integer  "calls_sep",                                        :default => 0
    t.integer  "calls_oct",                                        :default => 0
    t.integer  "calls_nov",                                        :default => 0
    t.integer  "calls_dec",                                        :default => 0
    t.decimal  "earnings_yesterday", :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_last_7",    :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_mtd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_last_mos",  :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_qtd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_last_qtr",  :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_ytd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_last_yr",   :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_total",     :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_jan",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_feb",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_mar",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_apr",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_may",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_jun",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_jul",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_aug",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_sep",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_oct",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_nov",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "earnings_dec",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_mtd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_last_mos",  :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_qtd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_last_qtr",  :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_ytd",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_last_yr",   :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_total",     :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_jan",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_feb",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_mar",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_apr",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_may",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_jun",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_jul",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_aug",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_sep",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_oct",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_nov",       :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "payments_dec",       :precision => 9, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "usercreditcard", :primary_key => "CreditCardId", :force => true do |t|
    t.string  "UserId",          :limit => 36, :null => false
    t.string  "PaymentMethodId", :limit => 36, :null => false
    t.boolean "Active",                        :null => false
    t.boolean "Primary",                       :null => false
  end

  add_index "usercreditcard", ["CreditCardId"], :name => "CreditCardId", :unique => true

  create_table "users", :force => true do |t|
    t.integer   "role_id",               :limit => 2,                                                   :null => false
    t.string    "referrer_id",           :limit => 45,                                :default => "1"
    t.string    "email",                 :limit => 250
    t.string    "password_digest"
    t.string    "company",               :limit => 45
    t.string    "first",                 :limit => 45
    t.string    "last",                  :limit => 45
    t.string    "address1",              :limit => 36
    t.string    "address2",              :limit => 45
    t.string    "phone_w",               :limit => 36
    t.string    "phone_m",               :limit => 45
    t.string    "fax",                   :limit => 36
    t.boolean   "status"
    t.datetime  "created_at",                                                                           :null => false
    t.timestamp "updated_at"
    t.string    "city",                  :limit => 45
    t.string    "state",                 :limit => 45
    t.string    "zip",                   :limit => 45
    t.string    "country",               :limit => 45
    t.integer   "ad_budget",             :limit => 2
    t.integer   "budget_period",         :limit => 2
    t.boolean   "bootcamp_m"
    t.boolean   "bootcamp_p"
    t.decimal   "rate",                                 :precision => 4, :scale => 3, :default => 0.01
    t.integer   "pay_threshhold",        :limit => 2,                                 :default => 0
    t.boolean   "pay_method"
    t.string    "paypal_email",          :limit => 45
    t.string    "recover_hash"
    t.datetime  "recover_expires_in"
    t.boolean   "pwidget"
    t.boolean   "pfacebook"
    t.boolean   "pemail"
    t.boolean   "ptwitter"
    t.boolean   "ptexting"
    t.boolean   "pcoldcall"
    t.boolean   "pphone_list"
    t.decimal   "override",                             :precision => 4, :scale => 3, :default => 0.05
    t.boolean   "pdisplayads"
    t.string    "salutation",            :limit => 5
    t.boolean   "papp_dist_intro"
    t.boolean   "pteam_build_intro"
    t.boolean   "pteam_build_contact"
    t.boolean   "pmanage_x_intro"
    t.boolean   "pmanage_x_contact"
    t.datetime  "cancelled_partnership"
    t.datetime  "cancelled_membership"
    t.integer   "infusionsoft_id"
    t.integer   "partner_order_id"
    t.boolean   "w9_status"
    t.datetime  "became_partner"
  end

  create_table "w9", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.string   "first",      :limit => 45
    t.string   "last",       :limit => 45
    t.string   "company",    :limit => 45
    t.string   "address",    :limit => 45
    t.string   "city",       :limit => 45
    t.string   "state",      :limit => 45
    t.string   "zip",        :limit => 45
    t.string   "country",    :limit => 45, :default => "USA"
    t.string   "tax_class",  :limit => 45
    t.boolean  "exempt"
    t.string   "tin",        :limit => 45
    t.string   "fti",        :limit => 45
    t.integer  "birth_year", :limit => 2
    t.boolean  "withhold"
    t.string   "signature",  :limit => 45
    t.string   "form_type",  :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip",         :limit => 45
  end

  add_index "w9", ["user_id"], :name => "w9_fk_users"

end
