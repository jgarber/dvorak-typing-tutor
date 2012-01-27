class App.LessonController extends Spine.Controller
  el: '#lesson_box'

  # elements:
  #   '.items': items
  # 
  # events:
  #   'click .item': 'itemClick'

  constructor: ->
    super
    @lesson = new App.Lesson(@el)
