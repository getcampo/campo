class ForumsController < ApplicationController
  def index
    @forums = Forum.order(topics_count: :desc)
  end

  def show
    @forum = Forum.find_by!(slug: params[:id])
    @topics = @forum.topics.includes(:user).order(activated_at: :desc).page(params[:page])
  end

  # constraints by routes
  # attribute: /name|slug/
  def validate
    user = Forum.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]
    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end
end
