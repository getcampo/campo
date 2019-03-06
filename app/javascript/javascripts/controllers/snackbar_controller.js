import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    let snackbar = this.element
    let hideOn = snackbar.dataset['hideOn']
    if (hideOn) {
      return setTimeout(function() {
        snackbar.addEventListener('animationend', function() {
          return this.remove()
        }, {
          once: true
        });
        return snackbar.classList.add('fadeOutDown')
      }, hideOn)
    }
  }
}
