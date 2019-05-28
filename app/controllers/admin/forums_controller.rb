class Admin::ForumsController < Admin::BaseController
  before_action :set_forum, only: [:show, :edit, :update]

  def index
    @forums = Forum.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new forum_params

    if @forum.save
      redirect_to admin_forum_url(@forum), notice: t('flash.forum_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    if @forum.update forum_params
      redirect_to admin_forum_url(@forum), notice: t('flash.forum_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  private

  def forum_params
    params.require(:forum).permit(:name, :slug, :description)
  end

  def set_forum
    @forum = Forum.find params[:id]
  end
end
