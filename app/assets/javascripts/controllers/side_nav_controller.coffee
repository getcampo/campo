application.register "side-nav", class extends Stimulus.Controller
  connect: ->
    toggle = document.querySelector("[data-toggle='##{this.element.id}']")
    toggle.addEventListener 'click', =>
      this.toggle()

  toggle: (event) ->
    this.element.classList.toggle('open')

  close: ->
    this.element.classList.remove('open')
