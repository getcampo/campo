class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to admin_user_url(@user), notice: t('flash.user_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      redirect_to admin_user_url(@user), notice: t('flash.user_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :slug, :description)
  end

  def set_user
    @user = User.find params[:id]
  end
end
