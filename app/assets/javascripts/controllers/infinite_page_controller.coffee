application.register "infinite-page", class extends Stimulus.Controller
  threshold: 400
  loading: false

  connect: ->
    document.addEventListener 'scroll', this.onScroll

  disconnect: ->
    document.removeEventListener 'scroll', this.onScroll

  onScroll: =>
    if this.loading
      return
    if this.element.dataset.infinitePageEnd
      this.disconnect()
      return

    rect = this.element.getBoundingClientRect()
    distance =  rect.height - (window.innerHeight - rect.top)
    if distance < this.threshold
      this.loading = true
      this.element.classList.add 'loading'
      nextPage = parseInt(this.element.dataset.infinitePage) + 1
      Rails.ajax
        url: this.element.dataset.infinitePageUrl + '?page=' + nextPage
        type: 'Get'
        dataType: 'script'
        complete: =>
          this.loading = false
          this.element.classList.remove 'loading'
