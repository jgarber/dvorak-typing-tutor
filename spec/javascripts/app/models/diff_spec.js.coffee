describe 'Diff', ->
  beforeEach ->
    window.app = new App

  describe '#strip_extra_spaces', ->
    it 'sholud strip extra spaces', ->
      expect(app.diff.strip_extra_spaces('some string with        extra spaces')).toEqual('some string with extra spaces')

  describe '#strip_eol_symbols', ->
    it 'sholud strip eol symbols', ->
      expect(app.diff.strip_eol_symbols("some\n string")).toEqual('some string')

  describe '#convert_to_lesson_format', ->
    it 'should fetch p tags content', ->
      expect(app.diff.convert_to_lesson_format("<p>some text here</p>  <p>and another one</p>")).toEqual('some text here⏎ and another one')

