class BoardsController < ApplicationController
  layout 'base', only: [:new, :edit]

  before_action :require_sign_in, except: [:index]

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new board_params

    if @board.save
      redirect_to @board, notice: "Board is successfully created."
    else
      render 'update_form'
    end
  end

  def show
    @board = Board.find_by!(slug: params[:id])
  end

  def edit
    @board = Board.find_by!(slug: params[:id])
  end

  def update
    @board = Board.find_by!(slug: params[:id])

    if @board.update board_params
      redirect_to @board, notice: "Board is successfully updated."
    else
      render 'update_form'
    end
  end

  # constraints by routes
  # attribute: /name|slug/
  def validate
    user = Board.new(params[:attribute] => params[:value])
    user.valid?
    errors = user.errors[params[:attribute]]
    render json: {
      valid: errors.empty?,
      message: errors.first
    }
  end

  private

  def board_params
    params.require(:board).permit(:name, :slug, :description)
  end
end
