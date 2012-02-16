describe 'Help', ->
  beforeEach ->
    window.app = new App
    window.help = window.app.help

  it 'should return current layout', ->
    expect(help.layout()).toEqual(app.keyboard_controller.keyboard.get_current_layout())

  it 'should return a key index', ->
    expect(help.index('a')).toEqual(26)

  it 'should return o key index', ->
    expect(help.index('o')).toEqual(27)

  it 'should return z key index', ->
    expect(help.index('z')).toEqual(46)

  describe 'row detection', ->
    describe 'for lower letters', ->
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

    describe 'for upper letters', ->
      describe 'in number row', ->
        it 'should detect ~ key', ->
          expect(help.detect_row('~')).toEqual('number')

        it 'should detect # key', ->
          expect(help.detect_row('#')).toEqual('number')

        it 'should detect } key', ->
          expect(help.detect_row('}')).toEqual('number')

      describe 'in top row', ->
        it 'should detect " key', ->
          expect(help.detect_row('"')).toEqual('top')

        it 'should detect y key', ->
          expect(help.detect_row('y')).toEqual('top')

        it 'should detect | key', ->
          expect(help.detect_row('|')).toEqual('top')

      describe 'in home row', ->
        it 'should detect a key', ->
          expect(help.detect_row('a')).toEqual('home')

        it 'should detect o key', ->
          expect(help.detect_row('o')).toEqual('home')

        it 'should detect _ key', ->
          expect(help.detect_row('_')).toEqual('home')

      describe 'in bottom row', ->
        it 'should detect : key', ->
          expect(help.detect_row(':')).toEqual('bottom')

        it 'should detect x key', ->
          expect(help.detect_row('x')).toEqual('bottom')

        it 'should detect z key', ->
          expect(help.detect_row('z')).toEqual('bottom')

  describe 'hand detection', ->
    describe 'for lower letters', ->
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

    describe 'for upper letters', ->
      describe 'for left hand', ->
        it 'should detect # key', ->
          expect(help.detect_hand('#')).toEqual('left')

        it 'should detect > key', ->
          expect(help.detect_hand('>')).toEqual('left')

        it 'should detect O key', ->
          expect(help.detect_hand('O')).toEqual('left')

        it 'should detect Q key', ->
          expect(help.detect_hand('Q')).toEqual('left')

      describe 'for right hand', ->
        it 'should detect & key', ->
          expect(help.detect_hand('&')).toEqual('right')

        it 'should detect C key', ->
          expect(help.detect_hand('C')).toEqual('right')

        it 'should detect T key', ->
          expect(help.detect_hand('T')).toEqual('right')

        it 'should detect W key', ->
          expect(help.detect_hand('W')).toEqual('right')
