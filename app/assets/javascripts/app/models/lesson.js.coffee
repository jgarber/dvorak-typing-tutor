class App.Lesson extends App.Base
  constructor: (el) ->
    @el                 = el
    @_current           = 0
    @_current_paragraph = 0
    @phrases            = []
    @paragraphs         = []
    @split_symbol       = '|'

    Spine.bind('app:start',  @set_all)
    Spine.bind('app:finish', @finish)

  set_lesson: (lesson) =>
    @_lesson = lesson
    @paragraphs = []
    # split lesson to paragraphs and chop each paragraph
    paragraphs = (paragraph.replace(/(^\s+)|([\n\r\s]+$)/g, '') for paragraph in lesson.split('\n'))

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
    @$('.next').html(@next() || '')

  set_previous: =>
    @$('.previous').html(@previous() || '')

  set_all: =>
    @set_next()
    @set_current()
    @set_previous()
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

  already_typed: =>
    @phrases.slice(0, @_current).join('')

  myst_be_typed: =>
    @phrases.slice(@_current).join('')
