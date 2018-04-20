class UsersController < ApplicationController
  before_action :load_identity, :require_unbind_identity

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      Current.identity.update(user: @user)
      sign_in(@user)
      redirect_to root_url
    else
      render :new, notice: 'Fail'
    end
  end

  private

  def require_unbind_identity
    if Current.identity.nil?
      redirect_to new_session_url
    elsif Current.identity.user.present?
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit(:name, :username, :email)
  end
end
