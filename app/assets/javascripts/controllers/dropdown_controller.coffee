application.register "dropdown", class extends Stimulus.Controller
  @targets: ['menu']

  open: (event) ->
    this.menuTarget.classList.add('open')
    document.addEventListener 'click', =>
      this.close()
    , once: true, capture: true

  close: ->
    this.menuTarget.classList.remove('open')
