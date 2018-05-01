application.register "form-validation", class extends Stimulus.Controller
  connect: ->
    controller = this
    form = this.element

    form.querySelectorAll('[data-validate-url]').forEach (input) ->
      input.addEventListener 'change', controller.validateRemote

    form.addEventListener 'ajax:before', controller.formSubmit

  validateRemote: (event) ->
    input = event.target
    fetch(input.dataset['validateUrl'], {
      method: 'post',
      body: "value=#{encodeURIComponent(input.value)}",
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
        'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      credentials: 'same-origin'
    })
    .then((response) -> response.json())
    .then((json) ->
      field = input.closest('.form-field')
      message = field.querySelector('.validate-message')
      if json.valid
        field.classList.remove('invalid')
        field.classList.add('valid')
        message?.remove()
      else
        field.classList.add('invalid')
        field.classList.remove('valid')
        unless message
          message = document.createElement('div')
          message.className = 'validate-message'
        message.textContent = json.message
        field.insertBefore(message, input.nextSibling)
    )

  formSubmit: (event) ->
    form = event.target
    pendingInputs = form.querySelectorAll('.form-field:not(.valid):not(.invalid) [data-validate-url]')
    if pendingInputs.length > 0
      event.preventDefault()
      pendingInputs.forEach (input) ->
        input.dispatchEvent(new Event('change'))
    else
      if form.querySelector('.invalid')
        event.preventDefault()
