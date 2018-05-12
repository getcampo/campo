application.register "visible-to-user", class extends Stimulus.Controller
  connect: ->
    unless Current.userId()
      this.element.remove()
