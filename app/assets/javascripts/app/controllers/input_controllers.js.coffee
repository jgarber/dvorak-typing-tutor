class App.InputController extends Spine.Controller
  el: '#input_box'

  events:
    'keydown': 'keydown'
    'keypress': 'keypress'
    'keyup': 'keyup'

  constructor: ->
    super
    @tmp_html = @el.html()
    @input = new App.Input(@el)

  keydown: (event) ->
    if event.which == 16
      Spine.trigger('input_box:shift_pressed') 

  keypress: (event) ->
    if event.which == 13
      Spine.trigger('input_box:return_pressed') 

  keyup: (event) ->
    if event.which == 16
      Spine.trigger('input_box:shift_released')

    if @tmp_html != @el.html()
      @tmp_html = @el.html()
      Spine.trigger('input_box:changed')
