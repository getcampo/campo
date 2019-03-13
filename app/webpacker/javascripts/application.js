import "bootstrap"

import Rails from "rails-ujs"
Rails.start()

import * as ActiveStorage from "activestorage"
ActiveStorage.start()

import Turbolinks from "turbolinks"
Turbolinks.start()

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

import "./cable"

import "./local_time"
