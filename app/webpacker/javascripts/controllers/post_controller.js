import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['container', 'formContainer']

  cancelEdit() {
    this.containerTarget.classList.remove('display-none');
    this.formContainerTarget.remove();
  }

  cancelReply() {
    this.formContainerTarget.remove();
    this.element.querySelector('.button-reply').classList.remove('disabled');
  }
}
