class App.Keyboard extends App.Base
  constructor: (el) ->
    @layout         = App.Layouts
    @count          = 47
    @current_layout = null
    @el             = el

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

  upcase: ->
    $('.keyboard > .key > .lower').hide()
    $('.keyboard > .key > .upper').show()

  downcase: ->
    $('.keyboard > .key > .lower').show()
    $('.keyboard > .key > .upper').hide()

