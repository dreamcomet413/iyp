class Offer < ActiveRecord::Base
  default_scope order("updated_at DESC")
  scope :active_offers, where(active: true)
  has_many :offer_histories

  GRACE_PERIOD = 5
  MALE_SALUTATIONS = ["Mr.", "Mr"]
  FEMALE_SALUTATIONS = ["Miss", "Mrs", "Ms"]

  def self.find_for_popup(categories, where, location, app_id = nil)
    gender = determine_gender(app_id)

    query = active_offers.find_by_gender(gender).find_by_current_day_and_minutes.check_for_offer_time_expirtaion_for_app(app_id)
    offers = {}
    if location.success && where.blank?
      offers[:zip] = find_by_zip(query, categories, location)
      offers[:city] = find_by_city(query, categories, location)
      offers[:state] = find_by_state(query, categories, location)
    end
    offers[:national] = find_by_national(query, categories, location)

    return offers[:zip] if offers[:zip]
    return offers[:city] if offers[:city]
    return offers[:state] if offers[:state]
    return offers[:national] if offers[:national]
    return nil
  end

  def as_json(options = {})
    h = super(options)
    h[:phone_number_from_num_matches] = determine_number_from_num_matches if self.num_type > 2 && self.display_type == 2
    h[:offer_history_id] = @offer_history_id
    h 
  end

  def assign_fields(app_id, ip, history_id)
    @app_id = app_id
    @ip = ip
    @offer_history_id = history_id
  end

  private


  def determine_number_from_num_matches
    match = NumMatch.where(num_type: self.num_type).order("updated_at ASC").last
    if match && match.display_num
      match.app_id = @app_id if @app_id
      match.offer_id = self.id
      match.term_num = self.term_num
      match.ip = @ip if @ip
      match.num_display_history_id = nil
      match.listing_id = nil
      match.expires = Time.zone.now + 5.minutes
      match.save
      match.display_num
    end
  end

  def self.determine_day
    Time.zone.now.strftime("%a").downcase
  end

  def self.determine_elapsed_minutes
    current_time = Time.zone.now
    hour = current_time.strftime("%H").to_i
    minute = current_time.strftime("%M").to_i
    (hour * 60) + minute
  end

  def self.determine_gender(app_id)
    return unless app_id
    app = App.find(app_id)
    user = User.find(app.user_id)
    salutation = user.salutation
    if MALE_SALUTATIONS.include?(salutation)
      :male
    elsif FEMALE_SALUTATIONS.include?(salutation)
      :female
    else
      nil
    end
  end

  def self.find_by_current_day_and_minutes
    day = determine_day
    elapsed_minutes = determine_elapsed_minutes
    query = "#{day}_start < ? AND #{day}_end > ?"
    where(query, elapsed_minutes, elapsed_minutes + GRACE_PERIOD)
  end

  def self.find_by_zip(query, categories, location)
    query.find_by_categories(categories).where(service_area: 'Zip', city: location.city, state: location.state).last
  end

  def self.find_by_state(query, categories, location)
    query.find_by_categories(categories).where(service_area: 'State', state: location.state).last
  end

  def self.find_by_city(query, categories, location)
    query.find_by_categories(categories).where(service_area: 'City', city: location.city, state: location.state).last
  end

  def self.find_by_national(query, categories, location)
    query.find_by_categories(categories).where(service_area: 'National').last
  end

  def self.find_by_categories(categories)
    where('(cat_1 IN (?) OR cat_2 IN (?) OR cat_3 IN (?) OR cat_4 IN (?)) OR (cat_1 LIKE ?)', categories, categories, categories, categories, 0)
  end

  def self.find_by_gender(gender)
    if gender == :male
      where{|o| (o.gender.in MALE_SALUTATIONS) | (o.gender.eq nil)}
    elsif gender == :female
      where{|o| (o.gender.in FEMALE_SALUTATIONS) | (o.gender.eq nil)}
    else
      scoped
    end
  end

  def self.check_for_offer_time_expirtaion_for_app(app_id)
    scoped unless app_id
    offer_histories = OfferHistory.where{ |o| (o.created_at > 30.days.ago) & (o.app_id == app_id)}.all
    offer_ids = offer_histories.map {|o| o.offer_id}.uniq
    if !offer_ids.empty?
      where('id NOT IN (?)', offer_ids)
      #scoped.joins { offer_histories }.where { (offer_histories.app_id != app_id) & (offer_histories.created_at  30.days.ago) }
    else
      scoped
    end
  end
end
