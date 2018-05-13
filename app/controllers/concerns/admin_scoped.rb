module AdminScoped
  extend ActiveSupport::Concern

  included do
    layout 'admin'

    before_action :require_sign_in, :require_admin
  end

  private

  def require_admin
    unless Current.user.admin?
      redirect_to root_path, alert: 'You have no permission.'
    end
  end
end
