class TopicsController < ApplicationController
  before_action :require_sign_in, except: :show
  before_action :set_topic, except: [:new, :create]
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_trash_permission, only: [:trash]

  def new
    @topic = Topic.new forum_id: params[:forum_id]
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
    position = (params[:position] || 1).to_i
    offset = if position < 10
      0
    elsif position > (@topic.comments.count - 10)
      @topic.comments.count - 20
    else
      position - 10
    end

    if offset < 0
      offset = 0
    end

    @comments = @topic.comments.order(id: :asc).includes(:user).offset(offset).limit(20)
    @comment = Comment.new topic: @topic

    if position > 1
      @target_comment = @topic.comments.order(id: :asc).offset(position - 2).first
    end
  end

  def edit
  end

  def update
    @topic.edited_by Current.user

    if @topic.update topic_params
      redirect_to @topic, notice: t('flash.topic_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  def trash
    @topic.trash
    redirect_to root_path, notice: t('flash.topic_is_successfully_deleted')
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
      redirect_to topic_url(@topic), alert: t('flash.you_have_no_permissions')
    end
  end

  def check_trash_permission
    unless Current.user.admin?
      redirect_to topic_url(@topic), alert: t('flash.you_have_no_permissions')
    end
  end
end
