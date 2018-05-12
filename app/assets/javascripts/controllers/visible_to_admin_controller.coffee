application.register "visible-to-admin", class extends Stimulus.Controller
  connect: ->
    unless Current.admin()
      this.element.remove()
