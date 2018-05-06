class AttachmentsController < ApplicationController
  before_action :require_sign_in

  def create
    attachment = Current.user.attachments.attach(params[:attachment][:file]).first

    render json: {
      filename: attachment.blob.filename,
      url: url_for(attachment)
    }
  end
end
