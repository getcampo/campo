class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate

  before_action :set_site

  private

  def set_site
    Current.site = Site.first || Site.create_default
  end
end
