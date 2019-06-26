class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate

  before_action :set_site, :check_setup_wizard

  private

  def set_site
    Current.site = Site.first || Site.create(
      title: 'Campo',
      logo: File.open(Rails.root.join('app', 'webpacker', 'images', 'logo.png')),
      icon: File.open(Rails.root.join('app', 'webpacker', 'images', 'logo.png')),
      setup_wizard_enabled: true
    )
  end

  def check_setup_wizard
    if Current.site.setup_wizard_enabled?
      redirect_to setup_path
    end
  end
end
