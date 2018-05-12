application.register "visible-to-creator-or-admin", class extends Stimulus.Controller
  connect: ->
    if (this.element.closest('[data-creator-id]').dataset.creatorId != document.querySelector('meta[name=current-user-id]').content) && (document.querySelector('meta[name=current-user-admin]').content != 'true')
      this.element.remove()
