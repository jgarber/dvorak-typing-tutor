describe 'Lesson', ->
  beforeEach ->
    window.app = new App
    @lesson = app.lesson_controller.lesson

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
