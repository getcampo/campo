class UsersController < ApplicationController
  layout 'base'

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in(@user)
      redirect_to root_url
    else
      render :new
    end
  end

  def check_username
    user = User.new(username: params[:value])
    user.valid?
    errors = user.errors[:username]
    render json: {
      valid: errors.empty?,
      message: errors.first || 'Looks good!'
    }
  end

  def check_email
    user = User.new(email: params[:value])
    user.valid?
    errors = user.errors[:email]
    render json: {
      valid: errors.empty?,
      message: errors.first || 'Looks good!'
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end
end
