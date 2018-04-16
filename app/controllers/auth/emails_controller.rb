class Auth::EmailsController < ApplicationController
  layout 'empty'

  def show
  end

  def create
    UserMailer.auth_email(params[:email]).deliver_later
  end

  def callback
  end
end
