class Settings::AccountsController < Settings::BaseController
  def show
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update user_params
      redirect_to settings_account_path, notice: t('flash.account_is_successfully_updated')
    else
      respond_to do |format|
        format.html { render 'show' }
        format.js { render 'update_form' }
      end
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
    params.require(:user).permit(:name, :username, :avatar, :bio)
  end
end
