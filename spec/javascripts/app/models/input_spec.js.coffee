describe 'Input', ->
  beforeEach ->
    window.app = new App

  it 'should strip tags from html', ->
    expect(app.input_controller.input.strip('Some <br/> string')).toEqual('Some  string')
