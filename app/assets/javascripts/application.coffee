#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require stimulus/dist/stimulus.umd
#= require local-time
#= require_self
#= require_tree .

window.application = Stimulus.Application.start()

window.Current =
  userId: ->
    document.querySelector('meta[name=current-user-id]')?.content

  admin: ->
    document.querySelector('meta[name=current-user-admin]')?.content == 'true'
