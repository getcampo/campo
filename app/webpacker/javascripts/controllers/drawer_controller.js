import { Controller } from "stimulus"

export default class DrawerController extends Controller {
  static keepOpen = false

  connect() {
    let toggle = document.querySelector(`[data-toggle='#${this.element.id}']`)
    toggle.addEventListener('click', () => {
      this.toggle()
    })

    if (DrawerController.keepOpen) {
      this.open()
    } else {
      this.close()
    }
  }

  disconnect() {
    if (window.innerWidth > 1200) {
      DrawerController.keepOpen = this.element.classList.contains('open')
    }
  }

  toggle(event) {
    this.element.classList.toggle('open')
  }

  open() {
    this.element.classList.add('open')
  }

  close() {
    this.element.classList.remove('open')
  }
}
