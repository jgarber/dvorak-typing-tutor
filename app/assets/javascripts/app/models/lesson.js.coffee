class App.Lesson extends App.Base
  constructor: (el) ->
    @el = el
    @_current = 0
    @lessons = []

  current: =>
    @lessons[@_current]

  next: =>
    @lessons[@_current + 1]

  previous: =>
    @lessons[@_current - 1]

  set_current: =>
    @$('.current').html(@current())

  set_next: =>
    @$('.next').html(@next())

  set_previous: =>
    @$('.previous').html(@previous())

  set_all: =>
    @set_next()
    @set_current()
    @set_previous()

  go_next: =>
    @_current += 1
    @set_all()
