import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['formContainer']

  cancelEdit() {
    this.formContainerTarget.remove();
    this.element.classList.remove('editing');
  }

  cancelReply() {
    this.formContainerTarget.remove();
    this.element.classList.remove('replying');
  }
}
