class HomeController < ApplicationController
  layout 'topics'

  def index
    @topics = Topic.includes(:user).order(activated_at: :desc).page(params[:page])

    render 'topics/index'
  end
end
