describe 'Lesson', ->
  beforeEach ->
    window.app = new App

    window.phrases = [
      'First string',
      'Second strig',
      'Some other string',
      'And another string',
      'Lorem Lorem'
    ]

    app.lesson_controller.lesson.phrases = phrases

  describe 'on initialization', ->
    it 'it should set current example to first in array', ->
      expect(app.lesson_controller.lesson.current()).toEqual(phrases[0])

    it 'it should set next example to second in array', ->
      expect(app.lesson_controller.lesson.next()).toEqual(phrases[1])

    it 'it should set previous example to null', ->
      expect(app.lesson_controller.lesson.previous()).toEqual(null)

  describe 'after 1 finished example', ->
    beforeEach ->
      app.lesson_controller.lesson.go_next()

    it 'it should set current example to second in array', ->
      expect(app.lesson_controller.lesson.current()).toEqual(phrases[1])

    it 'it should set next example to third in array', ->
      expect(app.lesson_controller.lesson.next()).toEqual(phrases[2])

    it 'it should set previous example to first in array', ->
      expect(app.lesson_controller.lesson.previous()).toEqual(phrases[0])
