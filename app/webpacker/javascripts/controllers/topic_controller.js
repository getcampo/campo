import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['slider', 'comments']

  connect() {
    this.sliderTarget.addEventListener('slider.change', this.visitPosition.bind(this))
  }

  visitPosition(event) {
    let url = new URL(location.href)
    url.searchParams.set('position', event.detail.value)
    console.log(url.href)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        this.commentsTarget.outerHTML = data.querySelector('#comments').outerHTML
        this.focusComment()
      }
    })
  }

  focusComment() {
    if (this.commentsTarget.dataset.focusId) {
      window.scrollTo(0, document.querySelector(`#comment-${this.commentsTarget.dataset.focusId}`).getBoundingClientRect().top + window.scrollY - 64)
    } else {
      window.scrollTo(0, 0)
    }
  }
}
