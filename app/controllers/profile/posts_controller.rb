class Profile::PostsController < Profile::BaseController
  def index
    @posts = @user.posts.order(id: :desc).page(params[:page])
  end
end
