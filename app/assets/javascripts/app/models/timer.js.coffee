class App.Timer extends App.Base
  constructor: (el) ->
    @el = el
    @running = false
    @seconds = 0
    @_stop = false

  start: =>
    @running = true

    unless @_stop
      @timeout_id = setTimeout(@timeout, 1000)
    else
      @_stop = false

  stop: =>
    @_stop = true

  timeout: =>
    @seconds += 1
    @render()
    @start()

  render: =>
    _minutes = (@seconds - @seconds % 60) / 60
    _seconds = @seconds % 60
    _hours   = (_minutes - _minutes % 60) / 60
    _minutes = _minutes % 60

    if _hours  == 0
      _hours = ''
    else
      if _hours   < 10
        _hours   = "0#{_hours}:"

    _minutes = "0#{_minutes}:" if _minutes < 10
    _seconds = "0#{_seconds}"  if _seconds < 10

    str = "#{_hours}#{_minutes}#{_seconds}"
    @el.html(str)

    str
