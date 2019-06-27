class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate

  before_action :set_site, :require_site

  private

  def set_site
    Current.site = Site.first
  end

  def require_site
    unless Current.site
      redirect_to setup_path
    end
  end
end
