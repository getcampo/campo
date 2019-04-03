class TopicsController < ApplicationController
  before_action :require_sign_in, except: :show
  before_action :set_topic, except: [:create]
  before_action :check_edit_permission, only: [:update, :trash]

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
      load_position_posts
    elsif params[:before]
      load_before_posts
    elsif params[:after]
      load_after_posts
    elsif params[:number]
      load_number_posts
    else
      load_default_posts
    end
  end

  def update
    @topic.update params.require(:topic).permit(:title)
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

  def load_position_posts
    position = params[:position].to_i
    @offset = position > 10 ? position - 10 : 0

    if @offset < 0
      @offset = 0
    end

    @posts = @topic.posts.order(number: :asc).includes(:user).offset(@offset).limit(20)

    if position > 1
      @focus_post = @topic.posts.order(number: :asc).offset(position - 2).first
    end

    if @offset == 0
      @reached_begin = true
    end

    if @offset + 20 >= @topic.posts.count
      @reached_end = true
    end
  end

  def load_before_posts
    post_id = params[:before].to_i
    position = @topic.posts.order(number: :asc).where("id < ?", post_id).count
    @offset = (position > 20) ? (position - 20) : 0
    @posts = @topic.posts.order(number: :asc).where("id < ?", post_id).offset(@offset).limit(20)
    if @offset == 0
      @reached_begin = true
    end
  end

  def load_after_posts
    post_id = params[:after].to_i
    position = @topic.posts.order(number: :asc).where("id < ?", post_id).count
    @offset = position + 1
    @posts = @topic.posts.order(number: :asc).offset(@offset).limit(20)
    if @offset == @topic.posts.count
      @reached_end = true
    end
  end

  def load_number_posts
    @focus_post = @topic.posts.find_by number: params[:number]
    if @focus_post
      position = @topic.posts.where("number < ?", @focus_post.number).count
      @offset = position > 10 ? position - 10 : 0
      @posts = @topic.posts.order(number: :asc).offset(@offset).limit(20)

      if @offset == 0
        @reached_begin = true
      end

      if @offset + 20 >= @topic.posts.count
        @reached_end = true
      end
    else
      load_default_posts
    end
  end

  def load_default_posts
    @offset = 0
    @posts = @topic.posts.order(number: :asc).includes(:user).limit(20)
    @reached_begin = true
    if @topic.posts.count <= 20
      @reached_end = true
    end
  end
end
