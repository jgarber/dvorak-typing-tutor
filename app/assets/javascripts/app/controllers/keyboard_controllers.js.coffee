class App.KeyboardController extends Spine.Controller
  el: '#keyboard'

  # elements:
  #   '.items': items
  # 
  # events:
  #   'click .item': 'itemClick'

  constructor: ->
    super
    @el.fill_keyboard('dvorak')
