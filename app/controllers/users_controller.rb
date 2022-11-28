class UsersController < ApplicationController
  include AuthPassword
  layout 'session'

  before_action :require_auth_password_enabled, only: [:create]

  def new
    if params[:return_to]
      session[:return_to] = URI(params[:return_to]).path
    end
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in(@user)
      redirect_to session.delete(:return_to) || root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # constraints by routes
  # attribute: /username|email/
  def validate
    user = User.new(user_params)
    user.valid?
    render json: {
      errors: user.errors[params[:attribute]]
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end
