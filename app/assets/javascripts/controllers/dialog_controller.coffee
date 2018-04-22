application.register "dialog", class extends Stimulus.Controller
  open: (event) ->
    this.element.classList.add('open')

  close: (event) ->
    this.element.classList.remove('open')
