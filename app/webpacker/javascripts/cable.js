import cable from 'actioncable'

window.App || (window.App = {})

window.App.cable = cable.createConsumer()

const context = require.context('./channels', true)
context.keys().forEach(context)
