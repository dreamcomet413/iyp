unless ENV["RAILS_ENV"] == 'test'
  Widget::Application.configure do
    # Only one these three option should be uncommented at time.
    #
    # Restrict access from all countries except USA and Canada
    config.restrict_access_from_all_countries_except_USA_and_Canada = false
  
    # If you want to configure white or black list manually, use one of these
    # two options.
    #
    # config.allow_access_only_from = ["US", "CA"]
    #
    # config.restrict_access_only_from = ["US", "CA"]
  end
end

