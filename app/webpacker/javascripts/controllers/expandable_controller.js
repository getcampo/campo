import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["focus"]

  open() {
    this.element.classList.add('expanded')
    if (this.hasFocusTarget) {
      this.focusTarget.focus()
    }
  }

  close() {
    this.element.classList.remove('expanded')
  }
}
