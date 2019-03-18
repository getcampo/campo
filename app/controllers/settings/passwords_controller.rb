class Settings::PasswordsController < Settings::BaseController
  include AuthPassword

  before_action :require_auth_password_enabled

  def show
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update user_params
      redirect_to settings_password_path, notice: t('flash.password_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
