import { Controller } from "stimulus"
import Current from '../current'

export default class extends Controller {
  connect() {
    if (!Current.admin()) {
      this.element.remove();
    }
  }
}
