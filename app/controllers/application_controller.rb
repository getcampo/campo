class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate

  before_action :set_site

  private

  def set_site
    Current.site = Site.first_or_create
  end
end
