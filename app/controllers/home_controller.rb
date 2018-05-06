class HomeController < ApplicationController
  def index
    @topics = Topic.order(activated_at: :desc).page(params[:page])
  end
end
