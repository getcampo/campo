class Admin::AttachmentsController < Admin::BaseController
  before_action :set_attachment, only: [:show, :destroy]

  def index
    @attachments = Attachment.order(id: :desc).page(params[:page])
  end

  def show
  end

  def destroy
    @attachment.destroy
    redirect_to admin_attachments_url, notice: I18n.t('flash.attachment_is_successfully_destroy')
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
