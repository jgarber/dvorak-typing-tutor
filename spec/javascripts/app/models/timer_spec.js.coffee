describe 'Timer', ->
  beforeEach ->
    window.app = new App
    window.timer = app.timer_controller.timer

  it 'should render 5 seconds to string', ->
    timer.seconds = 5
    expect(timer.render()).toEqual('00:05')

  it 'should render 15 seconds to string', ->
    timer.seconds = 15
    expect(timer.render()).toEqual('00:15')

  it 'should render 5 minutes to string', ->
    timer.seconds = 5 * 60
    expect(timer.render()).toEqual('05:00')

  it 'should render 15 minutes to string', ->
    timer.seconds = 15 * 60
    expect(timer.render()).toEqual('15:00')

  it 'should render 1 hour to string', ->
    timer.seconds = 1 * 60 * 60
    expect(timer.render()).toEqual('01:00:00')

  it 'should render 11 hour to string', ->
    timer.seconds = 11 * 60 * 60
    expect(timer.render()).toEqual('11:00:00')

  it 'should calculate words per minute', ->
    loadFixtures('words_per_minute')
    expect($('#words_per_minute:visible').length).toEqual(0)

    app.lesson_controller.lesson.lessons = [
      'some three words',
      'two words',
      'and finally four words'
    ]

    timer.seconds = 60
    timer.words_per_minute()

    expect($('#words_per_minute:visible').length).toEqual(1)
    expect($('#words_per_minute').html()).toContain(9)


