import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['input', 'replyToInput', 'replyToMessage']

  connect() {
    this.inputTarget.addEventListener('focus', this.focus.bind(this))
    this.inputTarget.addEventListener('blur', this.blur.bind(this))
    this.blurHanlder = this.blur.bind(this)
  }

  focus() {
    this.element.classList.add('focus')

    document.addEventListener('click', this.blurHanlder)
  }

  blur(event) {
    if (!this.element.contains(event.target)) {
      this.element.classList.remove('focus')
      document.removeEventListener('click', this.blurHanlder)
    }
  }

  bold() {
    this.wrapText('**', '**')
  }

  italic() {
    this.wrapText('*', '*')
  }

  heading() {
    this.prefixLine('## ')
  }

  quote() {
    this.prefixLine('> ')
  }

  link() {
    this.inputTarget.focus()
    let start = this.inputTarget.selectionStart
    let end = this.inputTarget.selectionEnd
    let selection = this.inputTarget.value.substring(start, end)
    if (selection.length) {
      document.execCommand('insertText', false, `[${selection}](url)`)
      this.inputTarget.setSelectionRange(start + selection.length + 3, start + selection.length + 6)
    } else {
      document.execCommand('insertText', false, `[](url)`)
      this.inputTarget.setSelectionRange(start + 1, start + 1)
    }
  }

  orderedList() {
    let number = 0
    this.prefixLine(() => {
      return `${number += 1}. `
    })
  }

  unorderedList() {
    this.prefixLine('- ')
  }

  wrapText(before, after) {
    this.inputTarget.focus()
    let start = this.inputTarget.selectionStart
    let end = this.inputTarget.selectionEnd
    let selection = this.inputTarget.value.substring(start, end)
    document.execCommand('insertText', false, `${before}${selection}${after}`)
    this.inputTarget.setSelectionRange(start + before.length, end + before.length)
  }

  prefixLine(prefix) {
    this.inputTarget.focus()
    let start = this.inputTarget.selectionStart
    let end = this.inputTarget.selectionEnd
    let lineStart = this.inputTarget.value.lastIndexOf("\n", start) + 1
    let lineEnd = this.inputTarget.value.indexOf("\n", end)
    if (lineEnd < 0) {
      lineEnd = this.inputTarget.value.length
    }
    let selection = this.inputTarget.value.substring(lineStart, lineEnd)

    let replaceText
    if (typeof prefix === 'function') {
      console.log('hit')
      replaceText = prefix() + selection.replace(/\n/g, function() {
        return `\n${prefix()}`
      })
    } else {
      replaceText = prefix + selection.replace(/\n/g, `\n${prefix}`)
    }

    this.inputTarget.setSelectionRange(lineStart, lineEnd)
    document.execCommand('insertText', false, replaceText)
  }

  attachFile(event) {
    Array.from(event.target.files).forEach(file => {
      let fileName = file.name
      let imageTag = `![Uplaoding ${fileName}...]()`
      this.textareaTarget.value = this.textareaTarget.value + imageTag
      let formData = new FormData()
      formData.append('attachment[file]', file)
      Rails.ajax({
        url: '/attachments',
        type: 'POST',
        dataType: 'json',
        data: formData,
        success: (data) => {
          this.textareaTarget.value = this.textareaTarget.value.replace(imageTag, `![${data.filename}](${data.url})`)
        }
      });
    })

    // reset file input
    event.target.value = '';
  }

  preview() {
    var formData;
    if (this.previewDialog) {
      this.previewDialog.querySelector('.dialog-body').textContent = 'Rendering...';
      this.application.getControllerForElementAndIdentifier(this.previewDialog, 'dialog').open();
    } else {
      this.element.insertAdjacentHTML('beforeend', `
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
      `)
      this.previewDialog = this.element.querySelector('.preview-dialog');
    }
    formData = new FormData()
    formData.append('content', this.textareaTarget.value)
    Rails.ajax({
      url: '/preview',
      type: 'POST',
      data: formData,
      success: (data, statusText, xhr) => {
        console.log(xhr.responseText);
        return this.previewDialog.querySelector('.dialog-body').innerHTML = xhr.responseText
      }
    });
  }

  cleanReplyTo() {
    this.replyToInputTarget.value = ''
    this.replyToInputTarget.disabled = true
    return this.replyToMessageTarget.classList.remove('show')
  }
}
