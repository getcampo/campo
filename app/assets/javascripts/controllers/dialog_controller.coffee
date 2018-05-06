application.register "dialog", class extends Stimulus.Controller
  connect: ->
    toggle = document.querySelector("[data-toggle='##{this.element.id}']")
    if toggle
      toggle.addEventListener 'click', =>
        this.open()

  open: (event) ->
    this.element.classList.toggle('open')

  close: ->
    this.element.classList.remove('open')
