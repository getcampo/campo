import { Controller } from "stimulus"
import Utils from 'javascripts/utils'

export default class extends Controller {
  static targets = ["backdrop"]

  connect() {
    this.element.composerController = this
  }

  open() {
    if (this.isOpen()) {
      return
    }

    this.element.classList.add('open')
    Utils.animateCSS(this.element, 'fadeInUp')
  }

  isOpen() {
    return this.element.classList.contains('open')
  }

  close() {
    let animationName = this.element.classList.contains('expand') ? 'fadeOut' : 'fadeOutDown';
    Utils.animateCSS(this.element, animationName, () => {
      this.element.classList.remove('open')

      if (this.element.classList.contains('expand')) {
        this.element.classList.remove('expand')
        this.backdropTarget.remove()
      }
    })
  }

  expand() {
    this.element.classList.add('expand')
    this.element.insertAdjacentHTML('beforeend', `
      <div class="composer-backdrop" data-target="composer.backdrop" data-action="click->composer#compress">
      </div>
    `)
    Utils.animateCSS(this.backdropTarget, 'fadeInHalf')
  }

  compress() {
    this.element.classList.remove('expand')
    Utils.animateCSS(this.backdropTarget, 'fadeOutHalf', () => {
      this.backdropTarget.remove()
    })
  }
}
