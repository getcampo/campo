class SearchController < ApplicationController
  def index
    @posts = Post.search(params[:query]).page(params[:page])
  end
end
