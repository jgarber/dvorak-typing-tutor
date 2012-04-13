class App.Input extends App.Base
  constructor: (el) ->

    Spine.bind('app:finish', @finish)

    Spine.bind('editor:ready',  @ready)

    Spine.bind('input_box:shift_pressed',  @shift_pressed)
    Spine.bind('input_box:shift_released', @shift_released)
    Spine.bind('input_box:changed',        @changed)
    Spine.bind('input_box:return_pressed', @return_pressed)

  ready: =>
    @editor = CKEDITOR.instances.input_box
    @highlight_next()

  finish: =>
    @editor.setReadOnly(true)

  append_content: (content) =>
    @set_content(@get_content() + content)

  set_content: (content = '') =>
    @editor.setData(content)
    @editor.focus()

  get_content: =>
    @editor.getData()

  clear: =>
    @set_content()

  shift_pressed: =>
    app.keyboard_controller.keyboard.upcase()

  shift_released: =>
    app.keyboard_controller.keyboard.downcase()

  changed: =>
    if @stripped_content() && app.lesson_controller.lesson.current()
      if @stripped_content() == app.lesson_controller.lesson.current()
        app.keyboard_controller.keyboard.highlight_return()
      else
        @highlight_next()

  next_string: =>
    content = (@stripped_content() || '').replace(/\n/g, '')
    content = content.replace(/\s$/g, '')
    content = content.replace(/^\s/g, '')
    console.clear()
    console.log "current lesson = '#{app.lesson_controller.lesson.current_lesson()}'"
    console.log "content = '#{content}'"

    if content == app.lesson_controller.lesson.current_lesson()
      Spine.trigger('app:finish')

    if content.length > 0
      regexp = new RegExp("^#{content}", 'i')
      str = app.lesson_controller.lesson.current_lesson().replace(regexp, '')
    else
      str = app.lesson_controller.lesson.current_lesson()

    console.log "next string = '#{str}'"
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
     str = str.replace(/\t/g, '') # trim str
   else
     ''

  stripped_content: =>
    @strip(@editor.getData() or '')

  return_pressed: =>
    #
