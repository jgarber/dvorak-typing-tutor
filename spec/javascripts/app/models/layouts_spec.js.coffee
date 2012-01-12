describe 'Layouts', ->
  it 'should contain dvorap lowercase layout', ->
    expect(Layouts['dvorak']['lowercase'].length).toEqual(47)

  it 'should contain dvorap uppercase layout', ->
    expect(Layouts['dvorak']['uppercase'].length).toEqual(47)
