# require 'rsolr'
require 'rsolr-ext'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup_app_id

  include RestrictAccess
  include CookieDetection

  def solr
    RSolr::Ext.connect :url => SOLR, :read_timeout => 120, :open_timeout => 12
  end

  private

  def check_secret_key
    unless params["key"].blank?
      if params["key"] != Digest::SHA1.hexdigest(Time.now.utc.hour.to_s+SECRET_KEY)
        if params["hour"].blank?
          render :json => {:status => "invalid key !!"}
        end
      end
    else
      render :json => {:status => "You have to include the key to request!"}
    end
  end

  def setup_app_id
    cookies[:app_id] = params[:a] if params[:a]
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/i
    end
  end

  helper_method :mobile_device?

end
