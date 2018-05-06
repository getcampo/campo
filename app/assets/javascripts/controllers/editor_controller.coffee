application.register "editor", class extends Stimulus.Controller
  @targets: ['textarea']

  attachFile: (event) ->
    for file in event.target.files
      fileName = file.name
      imageTag = "![#{fileName}](uplaoding...)"
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
