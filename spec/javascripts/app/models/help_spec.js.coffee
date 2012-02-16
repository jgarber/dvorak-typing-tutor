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
