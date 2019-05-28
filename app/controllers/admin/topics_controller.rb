class Admin::TopicsController < Admin::BaseController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.order(id: :desc).page(params[:page])
  end

  def show
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new topic_params

    if @topic.save
      redirect_to admin_topic_url(@topic), notice: t('flash.topic_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
  end

  def update
    if @topic.update topic_params
      redirect_to admin_topic_url(@topic), notice: t('flash.topic_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  def destroy
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :slug, :description)
  end

  def set_topic
    @topic = Topic.find params[:id]
  end
end
