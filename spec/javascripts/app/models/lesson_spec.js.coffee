describe 'Lesson', ->
  beforeEach ->
    window.app = new App

    window.lessons = [
      'First string',
      'Second strig',
      'Some other string',
      'And another string',
      'Lorem Lorem'
    ]

    app.lesson_controller.lesson.lessons = lessons

  describe 'on initialization', ->
    it 'it should set current example to first in array', ->
      expect(app.lesson_controller.lesson.current()).toEqual(lessons[0])

    it 'it should set next example to second in array', ->
      expect(app.lesson_controller.lesson.next()).toEqual(lessons[1])

    it 'it should set previous example to null', ->
      expect(app.lesson_controller.lesson.previous()).toEqual(null)

  describe 'after 1 finished example', ->
    beforeEach ->
      app.lesson_controller.lesson.go_next()

    it 'it should set current example to second in array', ->
      expect(app.lesson_controller.lesson.current()).toEqual(lessons[1])

    it 'it should set next example to third in array', ->
      expect(app.lesson_controller.lesson.next()).toEqual(lessons[2])

    it 'it should set previous example to first in array', ->
      expect(app.lesson_controller.lesson.previous()).toEqual(lessons[0])
