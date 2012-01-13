describe 'KeyboardController', ->
  it 'should fill keyboard with dvorak layout', ->
    loadFixtures('single_key')
    app = new App
    expect($('.lower').html()).toEqual('`')
    expect($('.upper').html()).toEqual('~')
