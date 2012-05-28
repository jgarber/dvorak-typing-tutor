describe 'Lesson', ->
  beforeEach ->
    window.app = new App
    @lesson = app.lesson_controller.lesson

  describe 'lesson initializing', ->
    it 'should split lesson on pagagraphs', ->
      @lesson.set_lesson('some text\n here\n  ')
      expect(@lesson.paragraphs.length).toEqual(2)
      expect(@lesson.paragraphs[0]).toEqual('some text⏎')
      expect(@lesson.paragraphs[1]).toEqual('here⏎')

    it 'should split paragraph on phrases', ->
      @lesson.set_lesson('some text| here ')
      expect(@lesson.phrases.length).toEqual(2)
      expect(@lesson.phrases[0]).toEqual('some text')
      expect(@lesson.phrases[1]).toEqual(' here')

    it 'should replace \\n to ⏎', ->
      @lesson.set_lesson('some text\n here ')
      expect(@lesson.phrases[0]).toEqual('some text⏎')


  describe 'phrases iteration', ->
    beforeEach ->
      window.phrases = [
        'First string',
        'Second strig',
        'Some other string',
        'And another string',
        'Lorem Lorem'
      ]

      @lesson.phrases = phrases

    describe 'on initialization', ->
      it 'it should set current example to first in array', ->
        expect(@lesson.current()).toEqual(phrases[0])

      it 'it should set next example to second in array', ->
        expect(@lesson.next()).toEqual(phrases[1])

      it 'it should set previous example to null', ->
        expect(@lesson.previous()).toEqual(null)

    describe 'after 1 finished example', ->
      beforeEach ->
        @lesson.go_next()

      it 'it should set current example to second in array', ->
        expect(@lesson.current()).toEqual(phrases[1])

      it 'it should set next example to third in array', ->
        expect(@lesson.next()).toEqual(phrases[2])

      it 'it should set previous example to first in array', ->
        expect(@lesson.previous()).toEqual(phrases[0])

    describe '#current_lesson', ->
      it 'should join phrases', ->
        @lesson.phrases = ['Some str', ' and etc']
        expect(@lesson.current_lesson()).toEqual('Some str and etc')

    describe 'detecting progress', ->
      beforeEach ->
        @lesson.go_next()

      describe '#already_typed', ->
        it 'detect typed phrases', ->
          expect(@lesson.already_typed()).toEqual('First string')

        it 'detect 2 typed phrases', ->
          @lesson.go_next()
          expect(@lesson.already_typed()).toEqual('First stringSecond strig')

      describe '#must_be_typed', ->
        it 'detect typed phrases', ->
          expect(@lesson.must_be_typed()).toEqual('Some other stringAnd another stringLorem Lorem')

        it 'detect 2 typed phrases', ->
          @lesson.go_next()
          expect(@lesson.must_be_typed()).toEqual('And another stringLorem Lorem')

      describe '#decorate_eol', ->
        it 'should add <p> after ⏎', ->
          out = "some ⏎<p class='break'>&nbsp;</p> text ⏎<p class='break'>&nbsp;</p> here"
          expect(@lesson.decorate_eol('some ⏎ text ⏎ here')).toEqual(out)
