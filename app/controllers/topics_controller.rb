class TopicsController < ApplicationController
  before_action :require_sign_in, except: :show
  before_action :set_topic, except: [:new, :create]
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_trash_permission, only: [:trash]

  def new
    @topic = Topic.new forum_id: params[:forum_id]
    @topic.build_first_post
  end

  def create
    @topic = Current.user.topics.new topic_params
    @topic.first_post.user = Current.user

    if @topic.save
      redirect_to @topic, notice: 'Topic is successfully created.'
    else
      render 'update_form'
    end
  end

  def show
    if params[:position]
      load_position_comments
    elsif params[:before]
      load_before_comments
    elsif params[:after]
      load_after_comments
    else
      load_normal_comments
    end

    @comment = Comment.new topic: @topic
  end

  def trash
    @topic.trash
    redirect_to root_path, notice: t('flash.topic_is_successfully_deleted')
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :forum_id, first_post_attributes: [:body])
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

  def load_position_comments
    position = params[:position].to_i
    @offset = if position < 10
      0
    elsif position > (@topic.comments.count - 10)
      @topic.comments.count - 20
    else
      position - 10
    end

    if @offset < 0
      @offset = 0
    end

    @comments = @topic.comments.order(id: :asc).includes(:user).offset(@offset).limit(20)

    if position > 1
      @focus_comment = @topic.comments.order(id: :asc).offset(position - 2).first
    end

    if @offset == 0
      @reached_begin = true
    end

    if @offset + 20 >= @topic.comments.count
      @reached_end = true
    end
  end

  def load_before_comments
    comment_id = params[:before].to_i
    position = @topic.comments.order(id: :asc).where("id < ?", comment_id).count
    @offset = (position > 20) ? (position - 20) : 0
    @comments = @topic.comments.order(id: :asc).where("id < ?", comment_id).offset(@offset).limit(20)
    if @offset == 0
      @reached_begin = true
    end
  end

  def load_after_comments
    comment_id = params[:after].to_i
    position = @topic.comments.order(id: :asc).where("id < ?", comment_id).count
    @offset = position + 1
    @comments = @topic.comments.order(id: :asc).offset(@offset).limit(20)
    if @offset == @topic.comments.count
      @reached_end = true
    end
  end

  def load_normal_comments
    @offset = 0
    @comments = @topic.comments.order(id: :asc).includes(:user).limit(20)
    @reached_begin = true
    if @topic.comments.count <= 20
      @reached_end = true
    end
  end
end
