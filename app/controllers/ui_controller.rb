class UiController < ApplicationController
  def page
    page = params[:page] || 'index'
    render page
  end
end
