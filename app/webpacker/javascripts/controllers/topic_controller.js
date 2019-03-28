import { Controller } from "stimulus"
import Rails from "rails-ujs"

export default class extends Controller {
  static targets = ['slider', 'posts', 'post', 'loadingBefore', 'loadingAfter']

  connect() {
    this.element.topicController = this
    this.sliderTarget.addEventListener('slider.change', this.visitPosition.bind(this))
    setTimeout(() => {
      this.updateIndex()
    }, 0)
    this.focuspost()
    this.onScrollHandle = this.onScroll.bind(this)

    document.addEventListener('scroll', this.onScrollHandle)
  }

  updateIndex() {
    this.recalculateIndex()
    this.updateSlider()
  }

  disconnect() {
    document.removeEventListener('scroll', this.onScrollHandle)
  }

  visitPosition(event) {
    let url = new URL(location.href)
    url.searchParams.set('position', event.detail.begin)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        this.postsTarget.outerHTML = data.querySelector('#posts').outerHTML
        this.recalculateIndex()
        this.updateSlider()
        this.focuspost()
      }
    })
  }

  focuspost() {
    if (this.postsTarget.dataset.focusId) {
      window.scrollTo(0, document.querySelector(`#post-${this.postsTarget.dataset.focusId}`).getBoundingClientRect().top + window.scrollY - 64)
    } else {
      window.scrollTo(0, 0)
    }
  }

  onScroll() {
    if (!this.loading) {
      let rect = this.postsTarget.getBoundingClientRect()
      if (rect.height - (window.innerHeight - rect.top) < 400) {
        this.loadAfter()
      }

      if (rect.top > -400) {
        this.loadBefore()
      }
    }

    this.updateHistory()
    this.updateSlider()
  }

  updateHistory() {
    if (this.scrollHistoryTimeout) {
      clearTimeout(this.scrollHistoryTimeout)
    }
    this.scrollHistoryTimeout = setTimeout(() => {
      let posts = this.visiblePosts()
      if (posts.length) {
        let post = posts[0]
        let topicId = this.element.dataset.topicId
        let number = parseInt(post.dataset.number)
        let path = number > 1 ? `/topics/${topicId}/${number}` : `/topics/${topicId}`
        history.replaceState(history.state, document.title, path)
      }
    }, 250)
  }

  loadBefore() {
    if (this.postsTarget.dataset.reachedBegin) {
      return
    }

    this.loading = true
    this.loadingBeforeTarget.classList.remove('d-none')
    let url = new URL(location.href)
    url.searchParams.set('before', this.postsTarget.dataset.beginId)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        let oldHeight = this.postsTarget.offsetHeight
        let oldScrollY = window.scrollY
        let postsElement = data.querySelector('#posts')
        this.postsTarget.insertAdjacentHTML('afterbegin', postsElement.innerHTML)
        this.postsTarget.dataset.beginId = postsElement.dataset.beginId
        this.postsTarget.dataset.reachedBegin = postsElement.dataset.reachedBegin
        this.postsTarget.dataset.offset = postsElement.dataset.offset
        window.scrollTo(0, oldScrollY + (this.postsTarget.offsetHeight - oldHeight))
        this.recalculateIndex()
        this.updateSlider()
      },
      complete: () => {
        this.loading = false
        this.loadingBeforeTarget.classList.add('d-none')
      }
    })
  }

  loadAfter() {
    if (this.postsTarget.dataset.reachedEnd) {
      return
    }

    this.loading = true
    this.loadingAfterTarget.classList.remove('d-none')
    let url = new URL(location.href)
    url.searchParams.set('after', this.postsTarget.dataset.endId)
    Rails.ajax({
      url: url.href,
      type: 'get',
      dataType: 'html',
      success: (data) => {
        let postsElement = data.querySelector('#posts')
        this.postsTarget.insertAdjacentHTML('beforeend', postsElement.innerHTML)
        this.postsTarget.dataset.endId = postsElement.dataset.endId
        this.postsTarget.dataset.reachedEnd = postsElement.dataset.reachedEnd
        this.recalculateIndex()
        this.updateSlider()
      },
      complete: () => {
        this.loading = false
        this.loadingAfterTarget.classList.add('d-none')
      }
    })
  }

  recalculateIndex() {
    let index = parseInt(this.postsTarget.dataset.offset)
    this.postsTarget.querySelectorAll('.post').forEach((post) => {
      post.dataset.index = index
      index += 1
    })
  }

  updateSlider() {
    let posts = this.visiblePosts()
    if (posts.length) {
      let begin = parseInt(posts[0].dataset.index) + 1
      let end = parseInt(posts[posts.length - 1].dataset.index) + 1
      let total = parseInt(this.postsTarget.dataset.total)
      this.sliderTarget.sliderController.setData(begin, end, total)
    }
  }

  // 64 is padding top with fixed navbar
  visiblePosts() {
    return Array.from(this.postTargets).filter((post) => {
      let postTop = post.getBoundingClientRect().y
      let postBottom = postTop + post.offsetHeight
      return (postTop > 64 && postTop < window.innerHeight) || (postBottom > 64 && postBottom < window.innerHeight) || (postTop < 64 && postBottom > window.innerHeight)
    })
  }
}
