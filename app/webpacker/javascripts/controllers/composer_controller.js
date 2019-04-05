import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.element.composerController = this
  }

  open() {
    if (this.isOpen()) {
      return
    }

    this.element.classList.add('open', 'animated', 'fadeInUp')

    let handleAnimationEnd = () => {
      this.element.classList.remove('animated', 'fadeInUp')
      this.element.removeEventListener('animationend', handleAnimationEnd)
    }

    this.element.addEventListener('animationend', handleAnimationEnd)
  }

  isOpen() {
    return this.element.classList.contains('open')
  }

  close() {
    this.element.classList.add('animated', 'fadeOutDown')

    let handleAnimationEnd = () => {
      this.element.classList.remove('open', 'animated', 'fadeOutDown')
      this.element.removeEventListener('animationend', handleAnimationEnd)
    }

    this.element.addEventListener('animationend', handleAnimationEnd)
  }
}
