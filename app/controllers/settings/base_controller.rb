class Settings::BaseController < ApplicationController
  before_action :require_sign_in
end
