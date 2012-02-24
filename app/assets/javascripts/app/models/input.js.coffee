class App.Input extends App.Base
  constructor: (el) ->
    @el = el
    editor_config =
  		toolbar: [['Bold', 'Italic']]
  		removePlugins: 'elementspath' 
  		resize_enabled: false
  		customConfig: ''
  		toolbarStartupExpanded: false
  		language: 'en'
  		width: '600px'
  		height: '200px'
    $(@el).ckeditor(editor_config)

    Spine.bind('app:start',  @highlight_next)

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
   tmp.textContent || tmp.innerText

  stripped_content: =>
    out = @strip(@el.html())
    return out.replace(@strip('&#65279;'), '') if out # clear from rangy meta characters
    return out

  errors: =>
    current = app.lesson_controller.lesson.current().split(' ')
    input = @stripped_content().split(' ')

    out = {
      words: []
      present: false
    }

    for i in [0..(input.length - 1)]
      regexp = new RegExp("^#{input[i]}", 'i')
      if input[i].length > 0
        unless regexp.test(current[i])
          out.words.push([-1, input[i]])
          out.present = true
        else
          out.words.push([0, input[i]])

    out

  highlight_typos: (errors) =>
    @save_position() # creates hidden element in div
    html = @stripped_content()

    # get caret mark element
    mark_el = @$('.rangySelectionBoundary')

    if mark_el
      mark_el = mark_el.outerHTML()
      # get caret mark position
      mark = @strip(@el.html()).match(@strip('&#65279;'))
      # insper caret mark on previous position
      html = "#{html.substr(0, mark.index)}#{mark_el}#{html.substr(mark.index)}" if mark

    for word in errors.words
      # highlight typo
      if word[0] == -1
        # FIXME still can repsace some data in html tags, or wrong word
        regexp = new RegExp("#{word[1]}", 'i')
        # replace typo with typo wrapped in span.error
        html = html.replace(regexp, "<span class='error'>#{word[1]}</span>")

    # swap html in div
    @el.html(@hacks_for_browsers(html))
    # restore caret position
    @restore_position()

  hacks_for_browsers: (html) ->
    if navigator.userAgent.match('Mozilla')
      html += '<br _moz_dirty="">'

    html
