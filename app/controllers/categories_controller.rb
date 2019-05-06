class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:id])
    @topics = @category.topics.includes(:user).order(activated_at: :desc).page(params[:page])

    render 'topics/index'
  end
end
