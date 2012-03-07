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

    @voice               = new App.Voice
    @help                = new App.Help

    Spine.Route.setup()

  start: =>
    Spine.trigger('app:start')


window.App = App

$ ->
  window.app = new window.App
  window.app.start()
