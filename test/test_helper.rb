ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module SessionHelper
  def sign_in_as(user)
    cookies[:auth_token] = user.auth_token
  end

  def sign_out
    cookies[:auth_token] = nil
  end
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include SessionHelper

  setup do
    @site = create(:site)
  end
end
