application.register "visible-to-admin", class extends Stimulus.Controller
  connect: ->
    if document.querySelector('meta[name=current-user-admin]').content != 'true'
      this.element.remove()
