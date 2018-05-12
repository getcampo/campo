application.register "visible-to-creator", class extends Stimulus.Controller
  connect: ->
    unless this.element.closest('[data-creator-id]').dataset.creatorId == Current.userId()
      this.element.remove()
