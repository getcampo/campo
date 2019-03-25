import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['slider', 'comments', 'loadingBefore', 'loadingAfter']

  connect() {
    this.sliderTarget.addEventListener('slider.change', this.visitPosition.bind(this))
    this.focusComment()
    this.onScrollHandle = this.onScroll.bind(this)

    document.addEventListener('scroll', this.onScrollHandle)
  }

  disconnect() {
    document.removeEventListener('scroll', this.onScrollHandle)
  }

  visitPosition(event) {
    let url = new URL(location.href)
    url.searchParams.set('position', event.detail.value)
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

  onScroll() {
    if (!this.loading) {
      let rect = this.commentsTarget.getBoundingClientRect()
      if (rect.height - (window.innerHeight - rect.top) < 400) {
        console.log('load after')
        this.loadAfter()
      }

      if (rect.top > -400) {
        console.log('load before')
        this.loadBefore()
      }
    }
  }

  loadBefore() {
    if (this.commentsTarget.dataset.reachedBegin) {
      return
    }

    this.loading = true
    this.loadingBeforeTarget.classList.remove('d-none')
    let url = new URL(location.href)
    url.searchParams.set('before', this.commentsTarget.dataset.beginId)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        let oldHeight = this.commentsTarget.offsetHeight
        let commentsElement = data.querySelector('#comments')
        this.commentsTarget.insertAdjacentHTML('afterbegin', commentsElement.innerHTML)
        this.commentsTarget.dataset.beginId = commentsElement.dataset.beginId
        this.commentsTarget.dataset.reachedBegin = commentsElement.dataset.reachedBegin
        console.log(this.commentsTarget.offsetHeight)
        window.scrollTo(0, window.scrollY + (this.commentsTarget.offsetHeight - oldHeight))
      },
      complete: () => {
        this.loading = false
        this.loadingBeforeTarget.classList.add('d-none')
      }
    })
  }

  loadAfter() {
    if (this.commentsTarget.dataset.reachedEnd) {
      return
    }

    this.loading = true
    this.loadingAfterTarget.classList.remove('d-none')
    let url = new URL(location.href)
    url.searchParams.set('after', this.commentsTarget.dataset.endId)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        let commentsElement = data.querySelector('#comments')
        this.commentsTarget.insertAdjacentHTML('beforeend', commentsElement.innerHTML)
        this.commentsTarget.dataset.endId = commentsElement.dataset.endId
        this.commentsTarget.dataset.reachedEnd = commentsElement.dataset.reachedEnd
      },
      complete: () => {
        this.loading = false
        this.loadingAfterTarget.classList.add('d-none')
      }
    })
  }
}
