class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new post_params

    if @post.save
      redirect_to admin_post_url(@post), notice: t('flash.post_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    if @post.update post_params
      redirect_to admin_post_url(@post), notice: t('flash.post_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:name, :slug, :description)
  end

  def set_post
    @post = Post.find params[:id]
  end
end
