class App.Help
  layout_title: ->
    app.keyboard_controller.keyboard.current_layout

  layout: (_case) ->
    app.keyboard_controller.keyboard.get_current_layout(_case)

  index: (letter, _case = 'lowercase') ->
    @layout(_case).indexOf(letter)

  index_for_any_case: (letter) ->
    index = @index(letter)
    index = @index(letter, 'uppercase') if index is -1

    index

  detect_row: (letter) ->
    index = @index_for_any_case(letter)

    if index isnt -1
      return 'number' if index >= 0  and index <= 12
      return 'top'    if index >= 13 and index <= 25
      return 'home'   if index >= 26 and index <= 36
      return 'bottom' if index >= 37 and index <= 46
    else
      throw "Undefined ROW for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"

  detect_hand: (letter) ->
    index = @index_for_any_case(letter)

    if index isnt -1
      return 'left'  if (index >= 0  and index <= 5 ) or (index >= 13 and index <= 17) or (index >= 26 and index <= 30) or (index >= 37 and index <= 41)
      return 'right' if (index >= 6  and index <= 12) or (index >= 18 and index <= 25) or (index >= 31 and index <= 36) or (index >= 42 and index <= 46)
    else
      throw "Undefined HAND for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"
