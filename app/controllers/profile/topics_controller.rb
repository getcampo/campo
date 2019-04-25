class Profile::TopicsController < Profile::BaseController
  def index
    @topics = @user.topics.order(id: :desc).page(params[:page])
  end
end
