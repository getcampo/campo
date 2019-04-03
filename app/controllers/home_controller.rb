class HomeController < ApplicationController
  def index
    @topics = Topic.includes(:user).order(activated_at: :desc).page(params[:page])
    @topic = Topic.new
    @topic.build_first_post
  end
end
