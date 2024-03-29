class App.InputController extends Spine.Controller
  el: '#input_box'

  constructor: ->
    super
    @tmp_html = @el.html()
    @input = new App.Input(@el)
    @el.ckeditor(@ready,
      contentsCss: [
        '/assets/ckeditor/contents.css',
        '/assets/editor.css'
      ]
      extraPlugins: 'onchange,openscayt'
      minimumChangeMilliseconds: 100
      width: 640
      height: 140
      tabIndex: 0
      toolbarStartupExpanded: false
      toolbar: [['Bold', 'Italic']]
      removePlugins: 'elementspath,scayt'
      resize_enabled: false
      customConfig: ''
      language: 'en'
      startupFocus: true
    )

  ready: =>
    Spine.trigger('editor:ready')
    @bind_events()

  bind_events: ->
    CKEDITOR.instances.input_box.on('change', ->
      Spine.trigger('input_box:changed')
    )

    CKEDITOR.instances.input_box.document.on('keydown', (key)->
      if key.data.getKey() == 16
        Spine.trigger('input_box:shift_pressed')
    )

    CKEDITOR.instances.input_box.document.on('keyup', (key)->
      if key.data.getKey() == 16
        Spine.trigger('input_box:shift_released')
    )

    CKEDITOR.instances.input_box.document.on('keypress', (key)->
      if key.data.getKey() == 13
        Spine.trigger('input_box:return_pressed')
    )
