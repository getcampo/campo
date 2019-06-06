import { Controller } from "stimulus"
import Rails from "rails-ujs"
import Turbolinks from "turbolinks"

export default class extends Controller {
  connect() {
    this.element.addEventListener('submit', this.visit.bind(this))
  }

  visit() {
    Turbolinks.visit(this.element.action + '?' + Rails.serializeElement(this.element))
  }
}
