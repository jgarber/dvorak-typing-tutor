describe 'Keyboard', ->
  beforeEach ->
    window.app = new App

  beforeEach ->
    app.keyboard_controller.keyboard.layout =
      dvorak:
        lowercase: 'someletters'
        uppercase: 'asomeletters2'

  it 'should fetch lowerwcase layout from hash', ->
    expect(app.keyboard_controller.keyboard.get_layout('dvorak', 'lowercase')).toEqual('someletters')

  it 'should fetch upperaces layout from hash', ->
    expect(app.keyboard_controller.keyboard.get_layout('dvorak', 'uppercase')).toEqual('asomeletters2')

  it 'should split layout to array', ->
    result = app.keyboard_controller.keyboard.get_array('dvorak')
    expect($.isArray(result)).toBeTruthy()
    expect(result.length).toEqual(11)

  it 'should return count of letters', ->
    expect(app.keyboard_controller.keyboard.count).toEqual(47)

  it 'should fill key with upper and lower letter', ->
    loadFixtures('single_key')
    $('#keyboard').fill_keyboard('dvorak')
    expect($('.lower').html()).toEqual('s')
    expect($('.upper').html()).toEqual('a')
