class App.TimerController extends Spine.Controller
  el: '#lesson_box'

  constructor: ->
    super
    @timer = new App.Timer(@el)
