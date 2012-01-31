class App.Timer extends App.Base
  constructor: (el) ->
    @el            = el
    @running       = false
    @seconds       = 0
    @_stop         = false

    @_last_changed = 0
    Spine.bind('input_box:changed', @changed)
    Spine.bind('input_box:return_pressed', @changed)

  start: =>
    @running = true

    unless @_stop
      @timeout_id = setTimeout(@timeout, 1000)
    else
      @_stop   = false
      @running = false

  stop: =>
    @_stop = true

  timeout: =>
    @seconds += 1
    @render()
    @help()
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
      else
        _hours   = "#{_hours}:"

    if _minutes < 10
      _minutes = "0#{_minutes}:"
    else
      _minutes = "#{_minutes}:"

    if _seconds < 10
      _seconds = "0#{_seconds}"
    else
      _seconds = "#{_seconds}"

    str = "#{_hours}#{_minutes}#{_seconds}"
    @el.html(str)

    str

  changed: =>
    @_last_changed = @seconds

  help: =>
    if @seconds - @_last_changed >= 5
      @_last_changed = @seconds
      app.voice.help()
