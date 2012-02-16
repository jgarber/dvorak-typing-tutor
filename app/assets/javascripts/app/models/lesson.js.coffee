class App.Lesson extends App.Base
  constructor: (el) ->
    @el = el
    @_current = 0
    @phrases = ['a', 'o']
    @split_symbol = '|'

    Spine.bind('app:finish', @finish)

  set_lesson: (lesson) =>
    @lesson = lesson
    @phrases = @lesson.split(@split_symbol)

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
