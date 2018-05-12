class CommentsController < ApplicationController
  layout 'base'

  before_action :require_sign_in
  before_action :set_comment, except: [:create]
  before_action :check_edit_permission, only: [:edit, :update]
  before_action :check_trash_permission, only: [:trash]

  def create
    @comment = Current.user.comments.new comment_params

    if @comment.save
      render
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    @comment.edited_by Current.user

    if @comment.update comment_params
      redirect_to topic_url(@comment.topic, anchor: "comment-#{@comment.id}"), notice: 'Comment is successfully updated.'
    else
      render 'update_form'
    end
  end

  def trash
    @comment.trash
  end

  private

  def comment_params
    params.require(:comment).permit(:topic_id, :reply_to_comment_id, :content)
  end

  def set_comment
    @comment = Comment.find params[:id]
  end

  def check_edit_permission
    unless @comment.user == Current.user or Current.user.admin?
      redirect_to topic_url(@comment.topic, anchor: "comment-#{@comment.id}"), alert: 'You have no permission.'
    end
  end

  def check_trash_permission
    unless Current.user.admin?
      redirect_to topic_url(@comment.topic, anchor: "comment-#{@comment.id}"), alert: 'You have no permission.'
    end
  end
end
