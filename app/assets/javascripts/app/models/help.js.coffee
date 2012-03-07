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
    return 'bottom' if letter is ' '

    index = @index_for_any_case(letter)

    if index isnt -1
      return 'number' if index >= 0  and index <= 12
      return 'top'    if index >= 13 and index <= 25
      return 'home'   if index >= 26 and index <= 36
      return 'bottom' if index >= 37 and index <= 46
    else
      throw "Undefined ROW for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"

  detect_hand: (letter) ->
    return 'any' if letter is ' '

    index = @index_for_any_case(letter)

    if index isnt -1
      return 'left'  if (index >= 0  and index <= 5 ) or (index >= 13 and index <= 17) or (index >= 26 and index <= 30) or (index >= 37 and index <= 41)
      return 'right' if (index >= 6  and index <= 12) or (index >= 18 and index <= 25) or (index >= 31 and index <= 36) or (index >= 42 and index <= 46)
    else
      throw "Undefined HAND for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"

  detect_finger: (letter) ->
    return 'thumb' if letter is ' '

    index = @index_for_any_case(letter)

    if index isnt -1
      return 'index'  if  [
                            4, 16, 29, 40, 5, 17, 30, 41, # left  hand
                            6, 18, 31, 42, 7, 19, 32, 43  # right hand
                          ].indexOf(index) isnt -1
      return 'middle' if  [
                            3, 15, 28, 39, # left  hand
                            44, 33, 20, 8  # right hand
                          ].indexOf(index) isnt -1
      return 'ring'   if  [
                            2, 14, 27, 38, # left  hand
                            45, 34, 21, 9  # right hand
                          ].indexOf(index) isnt -1
      return 'little' if  [
                            0, 1, 13, 26, 37,                      # left  hand
                            46, 35, 36, 22, 23, 24, 25, 10, 11, 12 # right hand
                          ].indexOf(index) isnt -1
    else
      throw "Undefined FINGER for letter \"#{letter}\" in layout \"#{@layout_title()}\" on position #{index}"

  detect_reach: (letter) ->
    return 'no' if letter is ' '

    index = @index_for_any_case(letter)

    if index isnt -1
      return 'left' if  [
                            0,             # left  hand
                            6, 18, 31, 42, # right hand
                          ].indexOf(index) isnt -1
      return 'right' if  [
                            5, 17, 30, 41,         # left  hand
                            11, 12, 23, 24, 25, 36 # right hand
                          ].indexOf(index) isnt -1

    return 'no'

  get_help: (letter) =>
   return "The #{letter} key is #{@detect_hand(letter)} hand, #{@detect_row(letter)} row, #{@detect_finger(letter)} finger, #{@detect_reach(letter)} rich."
