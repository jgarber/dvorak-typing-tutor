describe 'Layouts', ->
  it 'should contain dvorap lowercase layout', ->
    expect(App.Layouts['dvorak']['lowercase'].length).toEqual(47)

  it 'should contain dvorap uppercase layout', ->
    expect(App.Layouts['dvorak']['uppercase'].length).toEqual(47)
