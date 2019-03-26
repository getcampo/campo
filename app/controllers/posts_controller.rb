class PostsController < ApplicationController
  before_action :require_sign_in
  before_action :set_post, except: [:create]

  def create
    @post = Current.user.posts.new post_params

    if @post.save
      @post.topic.update activated_at: Time.now.utc
      render 'create'
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    @post.edited_user =  Current.user
    @post.edited_at = Time.now

    if @post.update post_params
      render 'update'
    else
      render 'update_form'
    end
  end

  private

  def post_params
    params.require(:post).permit(:topic_id, :reply_to_post_id, :body)
  end

  def set_post
    @post = Post.find params[:id]
  end
end
