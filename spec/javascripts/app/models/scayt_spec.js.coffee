describe 'Scayt', ->
  beforeEach ->
    window.app = new App
    app.scayt.current = ->
      'some text here'

  describe '#check', ->
    it 'should return empty array on empty string', ->
      expect(app.scayt.check('')).toEqual([])

    it 'should return array of 1 element', ->
      app.scayt.current = ->
        'here'
      errors = app.scayt.check('herep')
      expect(errors.length).toEqual(1)

      expect(errors[0].word).toEqual('herep')
      expect(errors[0].len).toEqual(5)
      expect(errors[0].code).toEqual(1)
      expect(errors[0].s.length).toEqual(1)

    it 'should return 0 errors if string is part of lesson', ->
      app.scayt.current = ->
        'here is some example'

      errors = app.scayt.check('here is som')

      expect(errors.length).toEqual(0)


  describe '#clean_text', ->
    it 'should remove \\n from text', ->
      expect(app.scayt.clean_text("\n").length).toEqual(0)

    it 'should remove &nbsp; from text', ->
      expect(app.scayt.clean_text("&nbsp;").length).toEqual(0)

    it 'should remove spaces from string', ->
      expect(app.scayt.clean_text("   aa   x  c     o     z  ").length).toEqual(10)

