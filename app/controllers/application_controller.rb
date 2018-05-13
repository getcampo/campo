class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale, Authenticate
end
