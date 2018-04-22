class Auth::EmailsController < ApplicationController
  layout 'session'

  def show
  end

  def create
    UserMailer.auth_email(params[:email]).deliver_later
  end
end
