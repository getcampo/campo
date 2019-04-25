class Profile::BaseController < ApplicationController
  before_action :set_user

  private

  def set_user
    @user = User.find_by! username: params[:username]
  end
end
