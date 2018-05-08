class ForumsController < ApplicationController
  layout 'base', only: [:new, :edit]

  before_action :require_sign_in, :require_admin, except: [:index, :show]

  def index
    @forums = Forum.order(topics_count: :desc)
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new forum_params

    if @forum.save
      redirect_to @forum, notice: "Forum is successfully created."
    else
      render 'update_form'
    end
  end

  def show
    @forum = Forum.find_by!(slug: params[:id])
    @topics = @forum.topics.order(activated_at: :desc).page(params[:page])
  end

  def edit
    @forum = Forum.find_by!(slug: params[:id])
  end

  def update
    @forum = Forum.find_by!(slug: params[:id])

    if @forum.update forum_params
      redirect_to @forum, notice: "Forum is successfully updated."
    else
      render 'update_form'
    end
  end

  # constraints by routes
  # attribute: /name|slug/
  def validate
    user = Forum.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]
    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end

  private

  def forum_params
    params.require(:forum).permit(:name, :slug, :description)
  end
end
