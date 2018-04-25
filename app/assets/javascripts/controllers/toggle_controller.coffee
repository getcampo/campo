application.register "toggle", class extends Stimulus.Controller
  connect: (event) ->
    this.element.addEventListener 'click', =>
      document.querySelector(this.element.dataset['target']).classList.toggle('open')
