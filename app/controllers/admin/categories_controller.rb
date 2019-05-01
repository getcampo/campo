class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.order(id: :desc).page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params

    if @category.save
      redirect_to admin_categories_url, notice: t('flash.category_is_successfully_created')
    else
      render 'update_form'
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]

    if @category.update category_params
      redirect_to admin_categories_url, notice: t('flash.category_is_successfully_updated')
    else
      render 'update_form'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :slug, :description)
  end
end
