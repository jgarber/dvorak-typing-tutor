#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require rangy/rangy-core
#= require rangy/rangy-selectionsaverestore

#= require_tree ./lib
#= require_self
#= require ./models/layouts
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./helpers
#= require_tree ./views

class App extends Spine.Controller
  el: 'body'

  constructor: ->
    super
    @input_controller    = new App.InputController
    @keyboard_controller = new App.KeyboardController
    @lesson_controller   = new App.LessonController
    @timer_controller    = new App.TimerController

    Spine.Route.setup()

window.App = App

$ ->
  window.app = new window.App
