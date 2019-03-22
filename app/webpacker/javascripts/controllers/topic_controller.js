import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['slider']

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
      dataType: 'script',
    })
  }
}
