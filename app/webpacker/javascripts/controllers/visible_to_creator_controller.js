import { Controller } from "stimulus"
import Current from '../current'

export default class extends Controller {
  connect() {
    let element = this.element.closest('[data-creator-id]')
    if (!(element && element.dataset.creatorId == Current.userId())) {
      this.element.remove()
    }
  }
}
