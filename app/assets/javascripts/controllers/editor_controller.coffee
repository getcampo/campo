application.register "editor", class extends Stimulus.Controller
  @targets: ['textarea', 'replyToInput', 'replyToMessage']

  attachFile: (event) ->
    for file in event.target.files
      fileName = file.name
      imageTag = "![Uplaoding #{fileName}...]()"
      this.textareaTarget.value = this.textareaTarget.value + imageTag
      formData = new FormData()
      formData.append 'attachment[file]', file
      Rails.ajax
        url: '/attachments'
        type: 'POST'
        dataType: 'json'
        data: formData
        success: (data) =>
          this.textareaTarget.value = this.textareaTarget.value.replace(imageTag, "![#{data.filename}](#{data.url})")

    # reset file input
    event.target.value = ''

  preview: ->
    if this.previewDialog
      this.previewDialog.querySelector('.dialog-body').textContent = 'Rendering...'
      this.application.getControllerForElementAndIdentifier(this.previewDialog, 'dialog').open()
    else
      this.element.insertAdjacentHTML('beforeend', """
        <div class="dialog open preview-dialog" data-controller="dialog">
          <div class="dialog-container">
            <div class="dialog-content">
              <div class="dialog-header">
                <h4 class="dialog-title">Markdown Preview</h4>
                <button type="button" class="button button-icon" data-action="dialog#close"><i class="material-icons">close</i></button>
              </div>
              <div class="dialog-body typography">
                Rendering...
              </div>
            </div>
            <div class="dialog-background" data-action="click->dialog#close"></div>
          </div>
        </div>
      """);
      this.previewDialog = this.element.querySelector('.preview-dialog')

    formData = new FormData()
    formData.append 'content', this.textareaTarget.value
    Rails.ajax
      url: '/preview'
      type: 'POST'
      data: formData
      success: (data, statusText, xhr) =>
        console.log xhr.responseText
        this.previewDialog.querySelector('.dialog-body').innerHTML = xhr.responseText

  cleanReplyTo: ->
    this.replyToInputTarget.value = ''
    this.replyToInputTarget.disabled = true
    this.replyToMessageTarget.classList.remove('show')
