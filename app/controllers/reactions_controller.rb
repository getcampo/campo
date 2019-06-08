class ReactionsController < ApplicationController
  before_action :require_sign_in, :set_post

  def create
    # TODO: use create_or_find in rails 6
    @reaction = Current.user.reactions.find_or_initialize_by(post: @post)
    @reaction.update(type: params[:type])
  end

  def destroy
    @reaction = Current.user.reactions.find_by! post: @post, type: params[:type]
    @reaction.destroy
  end

  private

  def set_post
    @post = Post.find params[:id]
  end
end
