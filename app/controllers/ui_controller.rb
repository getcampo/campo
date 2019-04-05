class UiController < ApplicationController
  layout 'base'

  def page
    page = params[:page] || 'index'
    render page
  end
end
