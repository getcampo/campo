application.register "expandable", class extends Stimulus.Controller
  expandMore: ->
    this.element.classList.add('expanded')

  expandLess: ->
    this.element.classList.remove('expanded')
