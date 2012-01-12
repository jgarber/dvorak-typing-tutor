#= require app/models/layouts
#= require app/models/keyboard
#= require app/helpers/jquery_fill_keyboard

describe 'Keyboard', ->

  beforeEach ->
    Keyboard.layout =
      dvorak:
        lowercase: 'someletters'
        uppercase: 'asomeletters2'

  it 'should fetch lowerwcase layout from hash', ->
    expect(Keyboard.get_layout('dvorak', 'lowercase')).toEqual('someletters')

  it 'should fetch upperaces layout from hash', ->
    expect(Keyboard.get_layout('dvorak', 'uppercase')).toEqual('asomeletters2')

  it 'should split layout to array', ->
    result = Keyboard.get_array('dvorak')
    expect($.isArray(result)).toBeTruthy()
    expect(result.length).toEqual(11)

  it 'should return count of letters', ->
    expect(Keyboard.count).toEqual(47)

  it 'should fill key with upper and lower letter', ->
    loadFixtures('single_key')
    $('.keyboard').fill_keyboard('dvorak')
    expect($('.lower').html()).toEqual('s')
    expect($('.upper').html()).toEqual('a')

  describe '$.fill_keyboard', ->

    it 'should set Keyboard.current_layout', ->
      loadFixtures('single_key')
      $('.keyboard').fill_keyboard('dvorak')
      expect(Keyboard.current_layout).toEqual('dvorak')
