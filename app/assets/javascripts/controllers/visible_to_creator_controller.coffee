application.register "visible-to-creator", class extends Stimulus.Controller
  connect: ->
    if this.element.closest('[data-creator-id]').dataset.creatorId != document.querySelector('meta[name=current-user-id]').content
      this.element.remove()
