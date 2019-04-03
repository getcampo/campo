import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['container']

  connect() {
    this.threshold = 400
    this.onScrollHandle = this.onScroll.bind(this)
    document.addEventListener('scroll', this.onScrollHandle)
  }

  disconnect() {
    document.removeEventListener('scroll', this.onScrollHandle)
  }

  onScroll() {
    if (this.loading) {
      return
    }

    if (this.data.get('reachedEnd') == 'true') {
      this.disconnect()
      return
    }

    let rect = this.element.getBoundingClientRect()
    let distance = rect.height - (window.innerHeight - rect.top)
    if (distance < this.threshold) {
      this.loading = true
      this.element.classList.add('loading')
      let nextPage = parseInt(this.data.get('page')) + 1
      let url = new URL(location.href)
      url.searchParams.set('page', nextPage)
      Rails.ajax({
        url: url.href,
        type: 'get',
        dataType: 'html',
        success: (data) => {
          const page = data.querySelector('[data-controller~=infinite-page]')
          this.data.set('page', page.dataset.infinitePagePage)
          this.data.set('reachedEnd', page.dataset.infinitePageReachedEnd)

          const container = data.querySelector('[data-target~="infinite-page.container"]')
          this.containerTarget.insertAdjacentHTML('beforeend', container.innerHTML)
        },
        complete: () => {
          this.loading = false
          this.element.classList.remove('loading')
        }
      })
    }
  }
}
