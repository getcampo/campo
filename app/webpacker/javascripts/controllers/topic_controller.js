import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['slider', 'comments', 'loadingBefore', 'loadingAfter']

  connect() {
    this.sliderTarget.addEventListener('slider.change', this.visitPosition.bind(this))
    this.recalculateIndex()
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
        this.recalculateIndex()
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
        this.loadAfter()
      }

      if (rect.top > -400) {
        this.loadBefore()
      }
    }

    let comment = Array.from(this.commentsTarget.querySelectorAll('.post')).find((comment) => {
      return comment.getBoundingClientRect().y > 0
    })
    this.sliderTarget.slider.setValue(parseInt(comment.dataset.index) + 2)
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
        let oldScrollY = window.scrollY
        //console.log(oldHeight)
        let commentsElement = data.querySelector('#comments')
        this.commentsTarget.insertAdjacentHTML('afterbegin', commentsElement.innerHTML)
        this.commentsTarget.dataset.beginId = commentsElement.dataset.beginId
        this.commentsTarget.dataset.reachedBegin = commentsElement.dataset.reachedBegin
        this.commentsTarget.dataset.offset = commentsElement.dataset.offset
        window.scrollTo(0, oldScrollY + (this.commentsTarget.offsetHeight - oldHeight))
        this.recalculateIndex()
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
        this.recalculateIndex()
      },
      complete: () => {
        this.loading = false
        this.loadingAfterTarget.classList.add('d-none')
      }
    })
  }

  recalculateIndex() {
    let index = parseInt(this.commentsTarget.dataset.offset)
    this.commentsTarget.querySelectorAll('.post').forEach((comment) => {
      comment.dataset.index = index
      comment.querySelector('.post-body').textContent = index
      index += 1
    })
  }
}
