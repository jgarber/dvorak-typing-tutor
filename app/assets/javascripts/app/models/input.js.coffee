class App.Input extends App.Base
  constructor: (el) ->
    @el = el
    @_diff = new diff_match_patch()

    Spine.bind('input_box:shift_pressed',  @shift_pressed)
    Spine.bind('input_box:shift_released', @shift_released)
    Spine.bind('input_box:return_pressed', @return_pressed)
    Spine.bind('input_box:changed',        @changed)

  save_position: =>
    @saved_position = rangy.saveSelection()

  restore_position: =>
    rangy.restoreSelection(@saved_position)


  shift_pressed: =>
    app.keyboard_controller.keyboard.upcase()

  shift_released: =>
    app.keyboard_controller.keyboard.downcase()

  return_pressed: =>
    if app.lesson_controller.lesson.current() == @stripped_content()
      @el.html('')

  changed: =>
    if @stripped_content() && app.lesson_controller.lesson.current()
      diff = @diff(
        @stripped_content(),
        app.lesson_controller.lesson.current()
      )

      if diff.length == 2 # all going ok
        # highlight next letter here
      else # must be typo in input
        @highlight_typos(diff)

  highlight_next: =>
    content = @stripped_content() || ''

    if (content.length > 0)
      diff = @diff(
        content,
        app.lesson_controller.lesson.current()
      )

      str = diff[diff.length - 1][1]
    else
      str = app.lesson_controller.lesson.current()

    next_letter = str[0]

    #app.keyboard_controller.keyboard.highlight_next(next_letter)
    app.voice.say(next_letter)

  diff: (str1, str2) =>
    @_diff.diff_main(str1, str2)

  strip: (html) ->
   tmp = document.createElement("DIV")
   tmp.innerHTML = html
   tmp.textContent ||tmp.innerText

  stripped_content: =>
    @strip(@el.html())

  highlight_typos: (diff) =>
    html = ''

    for match in diff
      if match[0] == -1
        html += "<span class='error'>#{match[1]}</span>"
      if match[0] == 0
        html += match[1]

    @save_position()
    #@el.html(html)
    console.log(@el.html())
    @restore_position()
