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
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include SessionHelper
end
