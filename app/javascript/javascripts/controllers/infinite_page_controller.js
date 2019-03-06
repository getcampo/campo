import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.threshold = 400
    this.loading = false
    document.addEventListener('scroll', this.onScroll.bind(this))
  }

  disconnect() {
    document.removeEventListener('scroll', this.onScroll.bind(this))
  }

  onScroll() {
    if (this.loading) {
      return
    }

    if (this.element.dataset.infinitePageEnd) {
      this.disconnect()
      return
    }

    let rect = this.element.getBoundingClientRect()
    let distance = rect.height - (window.innerHeight - rect.top)
    if (distance < this.threshold) {
      this.loading = true
      this.element.classList.add('loading')
      let nextPage = parseInt(this.element.dataset.infinitePage) + 1
      Rails.ajax({
        url: this.element.dataset.infinitePageUrl + '?page=' + nextPage,
        type: 'get',
        dataType: 'script',
        complete: () => {
          this.loading = false
          this.element.classList.remove('loading')
        }
      })
    }
  }
}
