application.register "visible-to-creator-or-admin", class extends Stimulus.Controller
  connect: ->
    unless (this.element.closest('[data-creator-id]').dataset.creatorId == Current.userId()) || Current.admin()
      this.element.remove()
