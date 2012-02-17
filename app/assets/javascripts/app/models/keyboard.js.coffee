class App.Keyboard extends App.Base
  constructor: (el) ->
    @layout         = App.Layouts
    @count          = 47
    @current_layout = null
    @el             = el

    Spine.bind('app:start',  @colorize_keys)
    Spine.bind('app:finish', @clear_highlighting)

  get_layout: (layout, _case) =>
    if @layout[layout]
      @layout[layout][_case]

  get_array: (layout, _case = 'lowercase') =>
    if @get_layout(layout, _case)
      @get_layout(layout, _case).split('')

  fill_keyboard: (layout) =>
    if @get_array(layout)
      @current_layout = layout
      for i in [0..(@count - 1)]
        key = $("#key_#{i}")
        if key
          key.children('.lower').html(@get_array(layout, 'lowercase')[i])
          key.children('.upper').html(@get_array(layout, 'uppercase')[i])

  get_current_layout: (_case = 'lowercase') =>
    @get_layout(@current_layout, _case)

  upcase: ->
    $('.keyboard > .key > .lower').hide()
    $('.keyboard > .key > .upper').show()

  downcase: ->
    $('.keyboard > .key > .lower').show()
    $('.keyboard > .key > .upper').hide()

  clear_highlighting: ->
    $('.keyboard > div').removeClass('highlighted')

  highlight_next: (letter) =>
    @clear_highlighting()

    if letter == 'return'
      $('.return').addClass('highlighted') 
    else
      if letter == ' '
        $('.space').addClass('highlighted') 
      else
        layout = @get_current_layout('lowercase')
        index = layout.indexOf(letter)

        if index != -1
          $("#key_#{index}").addClass('highlighted') 
        else
          layout = @get_current_layout('uppercase')
          index = layout.indexOf(letter)

          if index != -1
            $("#key_#{index}").addClass('highlighted') 
            $('.shift').addClass('highlighted') 

  highlight_return: =>
    @highlight_next('return')

  colorize_keys: =>
    for i in [0..(@count - 1)]
      key = $("#key_#{i}")
      if key
        color = @get_key_color(i)
        key.css('background-color', color)

  get_key_color: (index) =>
    alpha  = 1
    letter = @get_array(@current_layout)[index]
    finger = window.app.help.detect_finger(letter)
    hand   = window.app.help.detect_hand(letter)
    color  = "rgba(0, 0, 0, #{alpha})"

    if hand == 'left'
      switch finger
        when 'little' then color = "rgba(90, 93, 165, #{alpha})"
        when 'ring'   then color = "rgba(184, 97, 138, #{alpha})"
        when 'middle' then color = "rgba(192, 186, 84, #{alpha})"
        when 'index'  then color = "rgba(99, 191, 145, #{alpha})"

    if hand == 'right'
      switch finger
        when 'index'  then color = "rgba(90, 137, 80, #{alpha})"
        when 'middle' then color = "rgba(198, 157, 57, #{alpha})"
        when 'ring'   then color = "rgba(186, 95, 95, #{alpha})"
        when 'little' then color = "rgba(84, 155, 192, #{alpha})"

    color
