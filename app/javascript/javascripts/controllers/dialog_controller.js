import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    var toggle;
    toggle = document.querySelector(`[data-toggle='#${this.element.id}']`);
    if (toggle) {
      toggle.addEventListener('click', () => {
        this.open();
      })
    }
  }

  open(event) {
    this.element.classList.toggle('open')
  }

  close() {
    this.element.classList.remove('open')
  }
}
