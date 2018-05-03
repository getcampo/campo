application.register "snackbar", class extends Stimulus.Controller
  connect: ->
    snackbar = this.element
    if hideOn = snackbar.dataset['hideOn']
      setTimeout ->
        snackbar.remove()
      , hideOn
