import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['input', 'editArea', 'previewOutput']

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

  code() {
    this.inputTarget.focus()
    let start = this.inputTarget.selectionStart
    let end = this.inputTarget.selectionEnd
    let selection = this.inputTarget.value.substring(start, end)

    if (selection.includes("\n")) {
      let lineStart = this.inputTarget.value.lastIndexOf("\n", start) + 1
      let lineEnd = this.inputTarget.value.indexOf("\n", end)
      if (lineEnd < 0) {
        lineEnd = this.inputTarget.value.length
      }
      let content = this.inputTarget.value.substring(lineStart, lineEnd)
      let replaceText = "```\n" + content + "\n```\n"
      this.inputTarget.setSelectionRange(lineStart, lineEnd)
      document.execCommand('insertText', false, replaceText)
    } else {
      this.wrapText('`', '`')
    }
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
      replaceText = prefix() + selection.replace(/\n/g, function() {
        return `\n${prefix()}`
      })
    } else {
      replaceText = prefix + selection.replace(/\n/g, `\n${prefix}`)
    }

    this.inputTarget.setSelectionRange(lineStart, lineEnd)
    document.execCommand('insertText', false, replaceText)
  }

  attach(event) {
    this.inputTarget.focus()
    Array.from(event.target.files).forEach(file => {
      let fileName = file.name
      let pendingTag
      if (file.type.startsWith('image/')) {
        pendingTag = `![Uplaoding ${fileName}...]()`
      } else {
        pendingTag = `[Uplaoding ${fileName}...]()`
      }
      let start = this.inputTarget.selectionStart
      let end = this.inputTarget.selectionEnd
      document.execCommand('insertText', false, pendingTag)
      this.inputTarget.setSelectionRange(start + pendingTag.length, start + pendingTag)
      let formData = new FormData()
      formData.append('attachment[file]', file)
      Rails.ajax({
        url: '/attachments',
        type: 'POST',
        dataType: 'json',
        data: formData,
        success: (data) => {
          let start = this.inputTarget.selectionStart
          let end = this.inputTarget.selectionEnd
          let content;
          if (file.type.startsWith('image/')) {
            content = `![${data.filename}](${data.url})`
          } else {
            pendingTag = `[${data.filename}](${data.url})`
          }
          this.inputTarget.value = this.inputTarget.value.replace(pendingTag, content)
          this.inputTarget.setSelectionRange(start + content.length, end + content.length)
        }
      });
    })

    // reset file input
    event.target.value = '';
  }

  edit() {
    this.element.classList.remove('previewing')
  }

  preview() {
    this.previewOutputTarget.textContent = 'Loading...'
    this.element.classList.add('previewing')
    let formData = new FormData()
    formData.append('content', this.inputTarget.value)
    Rails.ajax({
      url: '/preview',
      type: 'POST',
      data: formData,
      success: (data, statusText, xhr) => {
        this.previewOutputTarget.innerHTML = xhr.responseText
      }
    });
  }
}
