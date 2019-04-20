class SubscriptionsController < ApplicationController
  before_action :require_sign_in, :set_topic

  def update
    @subscription = @topic.subscriptions.find_or_initialize_by(user: Current.user)
    @subscription.update status: params[:status]
  end

  def destroy
    @subscription = @topic.subscriptions.find_by(user: Current.user)
    @subscription&.destroy
    render :update
  end

  private

  def set_topic
    @topic = Topic.find params[:topic_id]
  end
end
