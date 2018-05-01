application.register "form-validation", class extends Stimulus.Controller
  connect: ->
    controller = this
    form = this.element

    form.querySelectorAll('[data-validate-url]').forEach (element) ->
      element.addEventListener 'change', controller.validateRemote

    form.addEventListener 'ajax:before', controller.formSubmit

  validateRemote: (event) ->
    element = event.target
    fetch(element.dataset['validateUrl'], {
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
      message = formGroup.querySelector('.validate-message')
      if json.valid
        formGroup.classList.remove('invalid')
        formGroup.classList.add('valid')
        message?.remove()
      else
        formGroup.classList.add('invalid')
        formGroup.classList.remove('valid')
        unless message
          message = document.createElement('div')
          message.className = 'validate-message'
        message.textContent = json.message
        formGroup.insertBefore(message, element.nextSibling)
    )

  formSubmit: (event) ->
    form = event.target
    pendingElements = form.querySelectorAll('.form-group:not(.valid):not(.invalid) [data-validate-url]')
    if pendingElements.length > 0
      event.preventDefault()
      pendingElements.forEach (element) ->
        element.dispatchEvent(new Event('change'))
    else
      if form.querySelector('.invalid')
        event.preventDefault()
