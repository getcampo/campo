class CommentsController < ApplicationController
  layout 'base'

  before_action :require_sign_in

  def create
    @comment = Current.user.comments.new comment_params

    if @comment.save
      render
    else
      render 'update_form'
    end
  end

  def edit
    @comment = Current.user.comments.find params[:id]
  end

  def update
    @comment = Current.user.comments.find params[:id]

    if @comment.update comment_params
      redirect_to topic_url(@comment.topic, anchor: "comment-#{@comment.id}"), notice: 'Comment is successfully updated.'
    else
      render 'update_form'
    end
  end

  def trash
    @comment = Current.user.comments.find params[:id]
    @comment.trash
  end

  private

  def comment_params
    params.require(:comment).permit(:topic_id, :content)
  end
end
