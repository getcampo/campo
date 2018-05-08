class TopicsController < ApplicationController
  layout 'base', except: [:show]

  before_action :require_sign_in, except: :show

  def new
    @topic = Topic.new
  end

  def create
    @topic = Current.user.topics.new topic_params

    if @topic.save
      redirect_to @topic, notice: 'Topic is successfully created.'
    else
      render 'update_form'
    end
  end

  def show
    @topic = Topic.find params[:id]
    @comment = Comment.new topic: @topic
  end

  def edit
    @topic = Current.user.topics.find params[:id]
  end

  def update
    @topic = Current.user.topics.find params[:id]

    if @topic.update topic_params
      redirect_to @topic, notice: 'Topic is successfully updated.'
    else
      render 'update_form'
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :forum_id, :content)
  end
end
