class App.Scayt
  #some string herep
  #[{"code":1,"pos":0,"row":0,"col":0,"len":5,"word":"herep","s":["here"]}]
  check: (text, hook) =>
    errors = []
    input  = @clean_text(text)
    sample = @current()

    if sample.indexOf(input) == 0 && sample.length >= input.length
      return errors

    input = input.split(' ')
    sample = sample.split(' ')

    for word, i in input
      if word.length > 0
        if sample[i] != word
          error =
            code: 1
            len: word.length
            word: word
            s: [input[i]]

          errors.push(error)

    console.log errors
    if hook
      hook(errors)
    else
      errors

  clean_text: (text) ->
    exps = ["\n", "&nbsp;", /^\s+/, /\s+$/]

    for exp in exps
      text = text.replace(exp, '')

    text = text.replace(/\s\s/, ' ') while text.match(/\s\s/)

    console.log text
    text

  current: ->
    app.lesson_controller.lesson.current()
