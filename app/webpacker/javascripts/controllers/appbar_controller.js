import { Controller } from "stimulus"

export default class extends Controller {
  openSearch() {
    this.element.classList.add('search-open')
    this.element.querySelector('.search-form input[name="query"]').focus()
  }

  closeSearch() {
    this.element.classList.remove('search-open')
  }
}
