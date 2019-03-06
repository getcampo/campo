import { Controller } from "stimulus"

export default class extends Controller {
  open(event) {
    this.element.classList.add('open');
    document.addEventListener('click', () => {
      this.close();
    }, { once: true, capture: true })
  }

  close() {
    this.element.classList.remove('open')
  }
}
