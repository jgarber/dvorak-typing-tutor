class App.Help
  layout_title: ->
    app.keyboard_controller.keyboard.current_layout

  layout: (_case) ->
    app.keyboard_controller.keyboard.get_current_layout(_case)

  index: (letter, _case = 'lowercase') ->
    @layout(_case).indexOf(letter)

  detect_row: (letter) ->
    index = @index(letter)
    index = @index(letter, 'uppercase') if index is -1

    if index isnt -1
      return 'number' if index >= 0  and index <= 12
      return 'top'    if index >= 13 and index <= 25
      return 'home'   if index >= 26 and index <= 36
      return 'bottom' if index >= 37 and index <= 46
    else
      throw "Undefined ROW for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"
