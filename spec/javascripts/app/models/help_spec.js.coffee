describe 'Help', ->
  beforeEach ->
    window.app = new App
    window.help = window.app.help

  it 'should return current layout', ->
    expect(help.layout()).toEqual(app.keyboard_controller.keyboard.get_current_layout())

  it 'index should be equal for lower and upper letters', ->
    expect(help.index_for_any_case('z')).toEqual(46)
    expect(help.index_for_any_case('Z')).toEqual(46)

  describe 'row detection', ->
    describe 'in number row', ->
      it 'should detect ` key', ->
        expect(help.detect_row('`')).toEqual('number')

      it 'should detect 3 key', ->
        expect(help.detect_row('3')).toEqual('number')

      it 'should detect ] key', ->
        expect(help.detect_row(']')).toEqual('number')

    describe 'in top row', ->
      it 'should detect \' key', ->
        expect(help.detect_row('\'')).toEqual('top')

      it 'should detect y key', ->
        expect(help.detect_row('y')).toEqual('top')

      it 'should detect \\ key', ->
        expect(help.detect_row('\\')).toEqual('top')

    describe 'in home row', ->
      it 'should detect a key', ->
        expect(help.detect_row('a')).toEqual('home')

      it 'should detect o key', ->
        expect(help.detect_row('o')).toEqual('home')

      it 'should detect - key', ->
        expect(help.detect_row('-')).toEqual('home')

    describe 'in bottom row', ->
      it 'should detect ; key', ->
        expect(help.detect_row(';')).toEqual('bottom')

      it 'should detect x key', ->
        expect(help.detect_row('x')).toEqual('bottom')

      it 'should detect z key', ->
        expect(help.detect_row('z')).toEqual('bottom')

  describe 'hand detection', ->
    describe 'for left hand', ->
      it 'should detect 3 key', ->
        expect(help.detect_hand('3')).toEqual('left')

      it 'should detect . key', ->
        expect(help.detect_hand('.')).toEqual('left')

      it 'should detect o key', ->
        expect(help.detect_hand('o')).toEqual('left')

      it 'should detect q key', ->
        expect(help.detect_hand('q')).toEqual('left')

    describe 'for right hand', ->
      it 'should detect 7 key', ->
        expect(help.detect_hand('7')).toEqual('right')

      it 'should detect c key', ->
        expect(help.detect_hand('c')).toEqual('right')

      it 'should detect t key', ->
        expect(help.detect_hand('t')).toEqual('right')

      it 'should detect w key', ->
        expect(help.detect_hand('w')).toEqual('right')

  describe 'finder detection', ->
    it 'should return thumb for space key', ->
      expect(help.detect_finger(' ')).toEqual('thumb')

    describe 'for left hand', ->
      it 'should detect a key', ->
        expect(help.detect_finger('a')).toEqual('little')

      it 'should detect o key', ->
        expect(help.detect_finger('o')).toEqual('ring')

      it 'should detect e key', ->
        expect(help.detect_finger('e')).toEqual('middle')

      it 'should detect u key', ->
        expect(help.detect_finger('u')).toEqual('index')

    describe 'for right hand', ->
      it 'should detect s key', ->
        expect(help.detect_finger('s')).toEqual('little')

      it 'should detect n key', ->
        expect(help.detect_finger('n')).toEqual('ring')

      it 'should detect t key', ->
        expect(help.detect_finger('t')).toEqual('middle')

      it 'should detect h key', ->
        expect(help.detect_finger('h')).toEqual('index')

  describe 'reach detection', ->
    describe 'for left hand', ->
      it 'should detect ` key', ->
        expect(help.detect_reach('`')).toEqual('left')

      it 'should detect a key', ->
        expect(help.detect_reach('a')).toEqual('no')

      it 'should detect i key', ->
        expect(help.detect_reach('i')).toEqual('right')

    describe 'for right hand', ->
      it 'should detect d key', ->
        expect(help.detect_reach('d')).toEqual('left')

      it 'should detect t key', ->
        expect(help.detect_reach('t')).toEqual('no')

      it 'should detect - key', ->
        expect(help.detect_reach('-')).toEqual('right')

  describe 'get_help', ->
    it 'should return hand, finger, reach', ->
      _s = help.get_help('z')
      expect(_s).toContain(help.detect_row('z'))
      expect(_s).toContain(help.detect_hand('z'))
      expect(_s).toContain(help.detect_finger('z'))
      expect(_s).toContain(help.detect_reach('z'))
