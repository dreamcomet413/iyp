module CookieDetection
 
  def self.included(base)
    base.before_filter :cookies_required, :except => ["cookie_test"]
  end
 
  def cookie_test
    if cookies["cookie_test"].blank?
      render "shared/cookies_required"
    else
      redirect_to(root_path)
    end
  end
 
  protected

  def cookies_required
    return true unless cookies["cookie_test"].blank?
    cookies["cookie_test"] = true
    redirect_to(cookie_test_path)
  end
end
