class App.Lesson extends App.Base
  constructor: (el) ->
    @el                 = el
    @_current           = 0
    @_current_paragraph = 0
    @phrases            = []
    @paragraphs         = []
    @split_symbol       = '|'
    @eol_symbol         = '⏎'

    Spine.bind('app:start',  @set_all)
    Spine.bind('app:finish', @finish)

  set_lesson: (lesson) =>
    @_lesson = lesson
    @paragraphs = []
    # split lesson to paragraphs and chop each paragraph
    lesson = lesson.replace(/\n/g, "⏎\n")
    paragraphs = (paragraph.replace(/(^\s+)|([n\r\s]+$)/g, '') for paragraph in lesson.split('\n'))

    for paragraph in paragraphs
      @paragraphs.push(paragraph) if paragraph.replace(/\s+/g, '').length > 0

    for paragraph in @paragraphs
      phrases = paragraph.split(@split_symbol)
      for phrase in phrases
        @phrases.push(phrase)

    @set_all()

  current: =>
    @phrases[@_current]

  next: =>
    @phrases[@_current + 1]

  previous: =>
    @phrases[@_current - 1]

  set_current: =>
    @$('.current').html(@current() || '')

  set_next: =>
    @$('.next').html(@must_be_typed() || '')

  set_previous: =>
    @$('.previous').html(@already_typed() || '')

  set_all: =>
    @set_previous()
    @set_current()
    @set_next()
    app.voice.say_phrase(@current())

  go_next: =>
    if @_current == @phrases.length - 1
      Spine.trigger('app:finish')
    else
      @_current += 1
      @set_all()

  finish: =>
    @$('.current').html('')
    @$('.next').html('')
    @$('.previous').html('')

  is_last: =>
    @_current == @phrases.length - 1

  current_lesson: =>
    @phrases.join('')

  input_content: =>
    # nothing here for now

  decorate_eol: (str) =>
    reg = new RegExp("#{@eol_symbol}", 'g')
    str.replace(reg, "#{@eol_symbol}</p><p class='break'>&nbsp;</p><p>")

  already_typed: =>
    @decorate_eol(@phrases.slice(0, @_current).join(''))

  must_be_typed: =>
    @decorate_eol(@phrases.slice(@_current + 1).join(''))
