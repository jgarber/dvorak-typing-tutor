$ ->
  window.input_box = $('.input_box')

  input_box.keydown (event) ->
    Spine.trigger('input_box:shift_pressed') if event.which == 16

  input_box.keypress (event) ->
    Spine.trigger('input_box:return_pressed') if event.which == 13

  @editable_content = input_box.html()
  input_box.keyup (event) ->
    Spine.trigger('input_box:shift_released') if event.which == 16

    if @editable_content != input_box.html()
      @editable_content = input_box.html()
      Spine.trigger('input_box:changed')
