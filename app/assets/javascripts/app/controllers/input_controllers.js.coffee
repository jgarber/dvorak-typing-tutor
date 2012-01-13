class App.InputController extends Spine.Controller
  el: '#input_box'

  events:
    'keydown': 'keydown'
    'keypress': 'keypress'
    'keyup': 'keyup'

  constructor: ->
    super
    @tmp_html = @el.html()

  keydown: (event) ->
    if event.which == 16
      Spine.trigger('input_box:shift_pressed') 
      $('.keyboard > .key > .lower').hide()
      $('.keyboard > .key > .upper').show()

  keypress: (event) ->
    if event.which == 13
      Spine.trigger('input_box:return_pressed') 
      @el.html('')

  keyup: (event) ->
    if event.which == 16
      Spine.trigger('input_box:shift_released')
      $('.keyboard > .key > .lower').show()
      $('.keyboard > .key > .upper').hide()

    if @tmp_html != @el.html()
      @tmp_html = @el.html()
      Spine.trigger('input_box:changed')

  move_cursor: ->
    nodes = @el.childNodes
    count = nodes.length
    range = document.createRange()
    sel   = window.getSelection()

    # set cursor position
    range.setStart(nodes[count - 1], nodes[count - 1].length)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)
