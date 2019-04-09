class NotificationsController < ApplicationController
  before_action :require_sign_in
  after_action :mark_all_as_read

  def index
    @notifications = Current.user.notifications.order(id: :desc).page(params[:page])
  end

  private

  def mark_all_as_read
    Current.user.notifications.unread.update_all read: true
  end
end
