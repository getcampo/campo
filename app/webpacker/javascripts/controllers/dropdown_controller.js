import { Controller } from "stimulus"

export default class extends Controller {
  open(event) {
    this.element.classList.add('open');
    document.addEventListener('click', () => {
      this.close();
    }, { once: true, capture: true })
    document.addEventListener('touchend', (event) => {
      // wait for item click trigger
      setTimeout(() => {
        this.close();
      }, 10)
    }, { once: true, capture: true })
  }

  close() {
    this.element.classList.remove('open')
  }
}
