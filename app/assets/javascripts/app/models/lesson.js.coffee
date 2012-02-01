class App.Lesson extends App.Base
  constructor: (el) ->
    @el = el
    @_current = 0
    @lessons = ['a', 'o']

    Spine.bind('app:finish', @finish)

  current: =>
    @lessons[@_current]

  next: =>
    @lessons[@_current + 1]

  previous: =>
    @lessons[@_current - 1]

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

  go_next: =>
    if @_current == @lessons.length - 1
      Spine.trigger('app:finish')
    else
      @_current += 1
      @set_all()

  finish: =>
    @$('.current').html('')
    @$('.next').html('')
    @$('.previous').html('')
