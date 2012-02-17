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
    alpha = 0.5

    for i in [0..(@count - 1)]
      key = $("#key_#{i}")
      if key
        letter = @get_array(@current_layout)[i]
        finger = window.app.help.detect_finger(letter)
        switch finger
          when 'middle' then color = "rgba(0, 255, 0, #{alpha})"
          when 'index'  then color = "rgba(255, 0, 0, #{alpha})"
          when 'ring'   then color = "rgba(0, 0, 255, #{alpha})"
          when 'little' then color = "rgba(0, 125, 125, #{alpha})"
          else               color = "rgba(0, 0, 0, #{alpha})"

        key.css('background-color', color)
