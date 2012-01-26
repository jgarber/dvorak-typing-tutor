class App.Input
  constructor: ->
    @el = $('#input_box')
    Spine.bind('input_box:shift_pressed', @shift_pressed)
    Spine.bind('input_box:shift_released', @shift_released)
    Spine.bind('input_box:return_pressed', @return_pressed)
    Spine.bind('input_box:changed', @changed)

  move_cursor: =>
    nodes = @el.childNodes
    count = nodes.length
    range = document.createRange()
    sel   = window.getSelection()

    # set cursor position
    range.setStart(nodes[count - 1], nodes[count - 1].length)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)

  shift_pressed: =>
    app.keyboard_controller.keyboard.upcase()

  shift_released: =>
    app.keyboard_controller.keyboard.downcase()

  return_pressed: =>
    @el.html('')

  changed: =>
