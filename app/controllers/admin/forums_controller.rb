class Admin::ForumsController < Admin::BaseController
  def index
    @forums = Forum.order(id: :desc).all
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new forum_params

    if @forum.save
      redirect_to admin_forums_url, notice: t('flash.forum_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
    @forum = Forum.find_by!(slug: params[:id])
  end

  def update
    @forum = Forum.find_by!(slug: params[:id])

    if @forum.update forum_params
      redirect_to admin_forums_url, notice: t('flash.forum_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  private

  def forum_params
    params.require(:forum).permit(:name, :slug, :description)
  end
end
