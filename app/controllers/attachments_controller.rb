class AttachmentsController < ApplicationController
  before_action :require_sign_in

  def create
    @attachment = Current.user.attachments.new attachment_params
    if @attachment.save
      render json: {
        filename: @attachment.file_identifier,
        url: attachment_path(token: @attachment.token, filename: @attachment.file_identifier)
      }
    else
      render json: {
        error: @attachment.errors.full_messages
      }
    end
  end

  def show
    @attachment = Attachment.find_by! token: params[:token]
    expires_in 5.minutes
    redirect_to @attachment.file.url
  end

  private

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end
