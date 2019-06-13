import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    let toggle = document.querySelector(`[data-toggle='#${this.element.id}']`)
    toggle.addEventListener('click', () => {
      this.toggle()
    })
  }

  toggle(event) {
    this.element.classList.toggle('open')
  }

  close() {
    this.element.classList.remove('open')
  }
}

document.addEventListener('turbolinks:before-cache', () => {
  document.querySelector('.drawer.open').classList.remove('open')
})
