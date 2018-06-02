class NotificationsController < ApplicationController
  layout 'base'

  before_action :require_sign_in

  def index
    @notifications = Current.user.notifications.order(id: :desc).page(params[:page])
  end
end
