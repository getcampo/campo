import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    let controller = this
    this.element.querySelectorAll('[data-validate-url]').forEach(input => {
      input.addEventListener('change', controller.validateRemote);
    });
  }

  validateRemote(event) {
    let input = event.target;
    return fetch(input.dataset['validateUrl'], {
      method: 'post',
      body: `value=${encodeURIComponent(input.value)}`,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
        'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      credentials: 'same-origin'
    }).then(function(response) {
      return response.json();
    }).then(function(json) {
      let field = input.closest('.form-field')
      let message = field.querySelector('.validate-message')
      if (json.valid) {
        field.classList.remove('invalid')
        field.classList.add('valid')
        if (message != null) {
          message.remove()
        }
      } else {
        field.classList.add('invalid')
        field.classList.remove('valid')
        if (!message) {
          message = document.createElement('div')
          message.className = 'validate-message'
        }
        message.textContent = json.message
        field.insertBefore(message, input.nextSibling)
      }
    })
  }
}
