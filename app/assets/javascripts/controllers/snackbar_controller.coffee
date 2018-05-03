application.register "snackbar", class extends Stimulus.Controller
  connect: ->
    snackbar = this.element
    if hideOn = snackbar.dataset['hideOn']
      setTimeout ->
        snackbar.addEventListener 'animationend', ->
          this.remove()
        , once: true
        snackbar.classList.add('fadeOutDown')
      , hideOn
