class App.TimerController extends Spine.Controller
  el: '#timer'

  constructor: ->
    super
    @timer = new App.Timer(@el)
