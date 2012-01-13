describe '$.fill_keyboard', ->

  it 'should set Keyboard.current_layout', ->
    loadFixtures('single_key')
    $('#keyboard').fill_keyboard('dvorak')
    expect(app.keyboard_controller.keyboard.current_layout).toEqual('dvorak')
