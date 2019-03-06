import { Controller } from "stimulus"

export default class extends Controller {
  expandMore() {
    this.element.classList.add('expanded')
  }

  expandLess() {
    this.element.classList.remove('expanded')
  }
}
