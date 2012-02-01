class App.Timer extends App.Base
  constructor: (el) ->
    @el            = el
    @running       = false
    @seconds       = 0

    @_last_changed = 0
    Spine.bind('input_box:changed', @changed)
    Spine.bind('input_box:return_pressed', @changed)
    Spine.bind('app:finish', @finish)

  start: =>
    @running = true
    window._break_timer = false
    @set_timeout()

  set_timeout: =>
    @timeout_id = setTimeout(@timeout, 1000) if @running

  stop: ->
    stop_timer()

  timeout: ->
    _timer = @app.timer_controller.timer

    unless @_break_timer
      _timer.seconds += 1
      _timer.render()
      _timer.help()
      _timer.set_timeout()

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

  finish: =>
    @words_per_minute()

  words_per_minute: =>
    words = 0
    for sample in app.lesson_controller.lesson.lessons
      words += sample.split(' ').length

    $('#words_per_minute').html("Words per minute: #{Math.ceil(words / @seconds / 60)}")
    $('#words_per_minute').show()
