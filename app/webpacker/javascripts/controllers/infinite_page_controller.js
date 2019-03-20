import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['placeholder']

  connect() {
    this.threshold = 400
    document.addEventListener('scroll', this.onScroll.bind(this))
  }

  disconnect() {
    document.removeEventListener('scroll', this.onScroll.bind(this))
  }

  onScroll() {
    if (this.data.get('loading') == 'true') {
      return
    }

    if (this.element.dataset.infinitePageEnd) {
      this.disconnect()
      return
    }

    let rect = this.element.getBoundingClientRect()
    let distance = rect.height - (window.innerHeight - rect.top)
    if (distance < this.threshold) {
      this.data.set('loading', 'true')
      let nextPage = parseInt(this.data.get('page')) + 1
      let url = new URL(location.href)
      url.searchParams.set('page', nextPage)
      Rails.ajax({
        url: url.href,
        type: 'get',
        dataType: 'script',
        complete: () => {
          this.data.set('loading', 'false')
          this.element.classList.remove('loading')
        }
      })
    }
  }
}
