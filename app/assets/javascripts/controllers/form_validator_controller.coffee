application.register "form-validator", class extends Stimulus.Controller
  connect: ->
    controller = this
    form = this.element

    form.querySelectorAll('[data-validate-remote]').forEach (element) ->
      element.addEventListener 'change', controller.validateRemote

    form.addEventListener 'ajax:before', controller.formSubmit

  validateRemote: (event) ->
    element = event.target
    fetch(element.dataset['validateRemote'], {
      method: 'post',
      body: "value=#{encodeURIComponent(element.value)}",
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
        'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
      },
      credentials: 'same-origin'
    })
    .then((response) -> response.json())
    .then((json) ->
      formGroup = element.closest('.form-group')
      if json.valid
        formGroup.classList.remove('is-invalid')
        formGroup.classList.add('is-valid')
      else
        formGroup.classList.add('is-invalid')
        formGroup.classList.remove('is-valid')
      message = formGroup.querySelector('.valid-message')
      unless message
        message = document.createElement('div')
        message.className = 'valid-message'
        formGroup.insertBefore(message, element.nextSibling)
      message.textContent = json.message
    )

  formSubmit: (event) ->
    form = event.target
    pendingElements = form.querySelectorAll('.form-group:not(.is-valid):not(.is-invalid) [data-validate-remote]')
    if pendingElements.length > 0
      event.preventDefault()
      pendingElements.forEach (element) ->
        element.dispatchEvent(new Event('change'))
    else
      if form.querySelector('.is-invalid')
        event.preventDefault()
