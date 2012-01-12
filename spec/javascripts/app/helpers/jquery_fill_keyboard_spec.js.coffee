describe '$.fill_keyboard', ->

  it 'should set Keyboard.current_layout', ->
    loadFixtures('single_key')
    $('.keyboard').fill_keyboard('dvorak')
    expect(Keyboard.current_layout).toEqual('dvorak')
