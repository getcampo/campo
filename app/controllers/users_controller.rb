class UsersController < ApplicationController
  include AuthPassword

  before_action :require_auth_password_enabled, only: [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in(@user)
      redirect_to root_url
    else
      render 'update_form'
    end
  end

  # constraints by routes
  # attribute: /name|username|email|password/
  def validate
    user = User.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]
    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end
