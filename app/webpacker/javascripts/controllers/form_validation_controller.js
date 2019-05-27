import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  connect() {
    let controller = this
    this.element.querySelectorAll('[data-validate-url]').forEach(input => {
      input.addEventListener('change', controller.validateRemote);
    });
  }

  validateRemote(event) {
    let input = event.target
    let formData = new FormData()
    formData.append('value', input.value)
    Rails.ajax({
      url: input.dataset.validateUrl,
      type: 'post',
      data: formData,
      success: (data) => {
        console.log(data)
        let field = input.closest('.form-field')
        let message = field.querySelector('.validate-message')

        if (data.valid) {
          field.classList.remove('invalid')
          field.classList.add('valid')
          if (message) {
            message.remove()
          }
        } else {
          field.classList.add('invalid')
          field.classList.remove('valid')
          if (!message) {
            message = document.createElement('div')
            message.className = 'validate-message'
          }
          message.textContent = data.message
          field.insertBefore(message, input.nextSibling)
        }
      }
    })
  }
}
