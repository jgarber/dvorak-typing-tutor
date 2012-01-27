class App.KeyboardController extends Spine.Controller
  el: '#keyboard'

  # elements:
  #   '.items': items
  # 
  # events:
  #   'click .item': 'itemClick'

  constructor: ->
    super
    @keyboard = new App.Keyboard(@el)
    @keyboard.fill_keyboard('dvorak')
