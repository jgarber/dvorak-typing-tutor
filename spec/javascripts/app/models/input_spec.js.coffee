describe 'Input', ->
  beforeEach ->
    @input = app.input_controller.input
    window.app = new App

  it 'should strip tags from html', ->
    expect(@input.strip('Some <br/> string')).toEqual('Some  string')

  it 'shoud return next string', ->
    @input.stripped_content = ->
      'some string here.And '
    app.lesson_controller.lesson.current_lesson = ->
      'some string here.And another one'
    expect(@input.next_string()).toEqual('another one')

