class App.Diff
  contstructor: ->

  eol_sym: ->
    app.lesson_controller.lesson.eol_symbol

  content: ->
    if app.input_controller.input.editor
      app.input_controller.input.get_content()
    else
      ''

  strip_extra_spaces: (str) ->
    while str.match(/\s\s/)
      str = str.replace(/\s\s/g, ' ')
    str = str.replace(/^\s/g, '').replace(/\s$/g, '')

    str

  strip_eol_symbols: (str) ->
    str.replace(/\n/g, '')

  convert_to_lesson_format: (str) =>
    out = []

    for p, i in $(str)
      html = $(p).html()
      if html && html.indexOf('&nbsp;') < 0
        out.push(html)
      else
        out[i - 1] += @eol_sym() if i > 0

    out = out.join(@eol_sym())

  remove_whitespaces: (str) ->
    str.split(/\s+/).join('')

  lesson: ->
    app.lesson_controller.lesson.paragraphs.join('').replace(new RegExp("\\#{app.lesson_controller.lesson.split_symbol}", 'g'), '')

  formatted_lesson: ->
    _lesson = @lesson()
    _lesson = @strip_extra_spaces(_lesson)
    _lesson = @strip_eol_symbols(_lesson)

  formatted_content: ->
    _content = @content()
    _content = @strip_extra_spaces(_content)
    _content = @strip_eol_symbols(_content)
    _content = @convert_to_lesson_format(_content)

  formatted_current: ->
    _current = app.lesson_controller.lesson.current_and_typed()
    _current = @strip_extra_spaces(_current)
    _current = @strip_eol_symbols(_current)

  compare: =>
    # make diff of input and lesson
    diff(@formatted_lesson().split(/\s+/), @formatted_content().split(/\s+/))

  errors: ->
    out = []

    for res in @compare()
      if res && res.file2
        for e in res.file2
          out.push(e) if e.length > 0

    out

  any_errors: =>
    _lesson  = @remove_whitespaces(@formatted_lesson())
    _content = @remove_whitespaces(@formatted_content())
    # if content is part of lesson or no errors we assume that everyting is fine
    not (_lesson.indexOf(_content) == 0 || @errors().length == 0)

  go_next: =>
    _current = @remove_whitespaces(@formatted_current())
    _content = @remove_whitespaces(@formatted_content())

    if _current == _content
      app.lesson_controller.lesson.go_next()

  next_letter: =>
    _lesson  = @remove_whitespaces(@formatted_lesson())
    _content = @remove_whitespaces(@formatted_content())
    @go_next()

    unless @any_errors()
      _lesson.replace(new RegExp("^#{_content}"), '')[0]
    else
      false
