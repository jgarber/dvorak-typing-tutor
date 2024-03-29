class App.Voice
  constructor: ->
    @voice_debug = []
    @beep_debug  = false

  say: (string) =>
    @voice_debug.push(string)

  say_phrase: (string, index) =>
    if string != @last_sayed_phrase || index != @last_sayed_index
      @last_sayed_index  = index
      @last_sayed_phrase = string
      @say(string)

  beep: ->
    @beep_debug = true
    if console && console.log
      console.log('beep')

  help: =>
    letter = app.input_controller.input.next_letter()
    @say(window.app.help.get_help(letter))
