class Settings::AccountsController < ApplicationController
  layout 'base'

  before_action :require_sign_in

  def show
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update user_params
      @user.avatar.attach params[:user][:avatar] if params[:user][:avatar].present?
      redirect_to settings_account_path, notice: t('flash.account_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  # constraints by routes
  # attribute: /name|username|email/
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
    params.require(:user).permit(:name, :username, :bio)
  end
end
