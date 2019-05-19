import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['container', 'formContainer']

  cancelEdit() {
    this.containerTarget.classList.remove('display-none');
    this.formContainerTarget.remove();
    this.element.classList.remove('focus');
  }

  cancelReply() {
    this.formContainerTarget.remove();
    this.element.querySelector('.post-footer').classList.remove('display-none');
    this.element.classList.remove('focus');
  }
}
