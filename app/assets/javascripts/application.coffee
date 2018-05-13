#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require stimulus/dist/stimulus.umd
#= require local-time
#= require_tree ./locales
#= require_self
#= require_tree .

window.application = Stimulus.Application.start()

window.Current =
  userId: ->
    document.querySelector('meta[name=current-user-id]')?.content

  admin: ->
    document.querySelector('meta[name=current-user-admin]')?.content == 'true'

  locale: ->
    document.querySelector('meta[name=locale]')?.content || 'en'

console.log Current.locale()
LocalTime.config.locale = Current.locale()
