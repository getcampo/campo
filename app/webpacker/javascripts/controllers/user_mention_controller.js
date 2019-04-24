import { Controller } from "stimulus"
import Rails from "rails-ujs"
import $ from "jquery"

export default class extends Controller {
  connect() {
    this.element.classList.add('badge', 'badge-secondary')
    this.hideTimer = null
    this.showHandler = this.show.bind(this)
    this.hideHandler = this.hide.bind(this)
    this.element.addEventListener('mouseenter', this.showHandler)
    this.element.addEventListener('mouseleave', this.hideHandler)
    $(this.element).on('inserted.bs.popover', () => {
      let popoverElement = document.querySelector(`#${this.element.getAttribute('aria-describedby')}`)
      popoverElement.addEventListener('mouseenter', this.showHandler)
      popoverElement.addEventListener('mouseleave', this.hideHandler)
    })
  }

  show() {
    if (this.hideTimer) {
      this.stopHide()
    } else {
      if (this.popover) {
        this.popover.popover('show')
      } else {
        this.popover = $(this.element).popover({
          html: true,
          content: `
            #todo ${this.element.dataset.username}
          `,
          placement: 'top'
        })
        this.popover.popover('show')
      }
    }
  }

  hide() {
    this.hideTimer = setTimeout(() => {
      this.popover.popover('hide')
      this.hideTimer = null
    }, 1000)
  }

  stopHide() {
    if (this.hideTimer) {
      clearTimeout(this.hideTimer)
      this.hideTimer = null
    }
  }
}
