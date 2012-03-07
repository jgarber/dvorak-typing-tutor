class App.Input extends App.Base
  constructor: (el) ->

    Spine.bind('app:finish', @finish)

    Spine.bind('editor:ready',  @ready)

    Spine.bind('input_box:shift_pressed',  @shift_pressed)
    Spine.bind('input_box:shift_released', @shift_released)
    Spine.bind('input_box:return_pressed', @return_pressed)
    Spine.bind('input_box:changed',        @changed)

  ready: =>
    @editor = CKEDITOR.instances.input_box
    @highlight_next()

  finish: =>
    @editor.setReadOnly(true)

  clear: =>
    @editor.setData('')
    @editor.focus()

  shift_pressed: =>
    app.keyboard_controller.keyboard.upcase()

  shift_released: =>
    app.keyboard_controller.keyboard.downcase()

  return_pressed: =>
    if app.lesson_controller.lesson.current() == @stripped_content()
      @clear()
      app.lesson_controller.lesson.go_next()
      @highlight_next()

  changed: =>
    if @stripped_content() && app.lesson_controller.lesson.current()
      if @stripped_content() == app.lesson_controller.lesson.current()
        if app.lesson_controller.lesson.is_last()
          Spine.trigger('app:finish')
        else
          app.keyboard_controller.keyboard.highlight_return()
      else
        @highlight_next()
        errors = @errors()
        @highlight_typos(errors)
        if errors.present
          app.voice.beep()

  next_string: =>
    content = @stripped_content() || ''

    if content.length > 0
      regexp = new RegExp("^#{content}", 'i')
      str = app.lesson_controller.lesson.current().replace(regexp, '')
    else
      str = app.lesson_controller.lesson.current()

    str

  next_letter: =>
    str = @next_string()

    if str
      next_letter = str[0]
    else
      false

  highlight_next: =>
    app.keyboard_controller.keyboard.highlight_next(@next_letter())

  strip: (html) ->
   tmp = document.createElement("DIV")
   tmp.innerHTML = html
   str = tmp.textContent or tmp.innerText

   if str
     str = str.replace(/\n|\t/g, '') # trim str
   else
     ''

  stripped_content: =>
    @strip(@editor.getData() or '')

  errors: =>
    # do nothing here for now
    []

  highlight_typos: (errors) =>
    # do nothing here for now
