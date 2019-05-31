class AttachmentsController < ApplicationController
  before_action :require_sign_in

  def create
    @attachment = Current.user.attachments.new attachment_params
    if @attachment.save
      render json: {
        filename: @attachment.file_identifier,
        url: @attachment.uri
      }
    else
      render json: {
        error: @attachment.errors.full_messages
      }
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
