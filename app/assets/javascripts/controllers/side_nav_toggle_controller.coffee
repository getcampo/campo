application.register "side-nav-toggle", class extends Stimulus.Controller
  toggle: (event) ->
    document.querySelector(this.element.dataset['target']).classList.toggle('open')
