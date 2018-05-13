class HomeController < ApplicationController
  def index
    @topics = Topic.includes(:user).order(activated_at: :desc).page(params[:page])
  end
end
