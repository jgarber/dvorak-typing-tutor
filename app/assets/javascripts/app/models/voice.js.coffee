class App.Voice
  say: (string) ->
    #if console && console.log
      #console.log(string)

  beep: ->
    #if console && console.log
      #console.log('beep')

  help: =>
      letter = app.input_controller.input.next_letter()
      if app.keyboard_controller.keyboard.current_layout == 'dvorak'
        @help_dvorak(letter)

  help_dvorak: (letter) =>
    if ['a'].indexOf(letter) != -1
      @say("The #{letter} key is on the home row, under your left little finger.")
    if ['t'].indexOf(letter) != -1
      @say("The #{letter} key is on the home row, under your right middle finger.")
