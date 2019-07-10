class Admin::SettingsController < Admin::BaseController
  def show
  end

  def update
    if Current.site.update site_params
      redirect_to admin_settings_path, notice: I18n.t('flash.site_is_successfully_created')
    else
      render 'update_form'
    end
  end

  private

  def site_params
    params.require(:site).permit(:title, :description, :logo, :icon)
  end
end
