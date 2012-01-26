class App.Lesson extends App.Base
  constructor: ->
    @_current = 'Some string here'

  current: =>
    @_current
