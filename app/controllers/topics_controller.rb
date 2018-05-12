class TopicsController < ApplicationController
  layout 'base', except: [:show]

  before_action :require_sign_in, except: :show
  before_action :set_topic, except: [:new, :create]
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_trash_permission, only: [:trash]

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
    @comment = Comment.new topic: @topic
  end

  def edit
  end

  def update
    @topic.edited_by Current.user

    if @topic.update topic_params
      redirect_to @topic, notice: 'Topic is successfully updated.'
    else
      render 'update_form'
    end
  end

  def trash
    @topic.trash
    redirect_to root_path, notice: 'Topic is successfully delete.'
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :forum_id, :content)
  end

  def set_topic
    @topic = Topic.find params[:id]
  end

  def check_edit_permission
    unless @topic.user == Current.user or Current.user.admin?
      redirect_to topic_url(@topic), alert: 'You have no permission.'
    end
  end

  def check_trash_permission
    unless Current.user.admin?
      redirect_to topic_url(@topic), alert: 'You have no permission.'
    end
  end
end
