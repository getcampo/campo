class Auth::EmailsController < ApplicationController
  layout 'base'

  def show
  end

  def create
    UserMailer.auth_email(params[:email]).deliver_later
  end
end
