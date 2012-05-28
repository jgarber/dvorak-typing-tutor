class App.Scayt
  #some string herep
  #[{"code":1,"pos":0,"row":0,"col":0,"len":5,"word":"herep","s":["here"]}]
  check: (hook) =>
    out = []

    if app.diff.any_errors()
      app.voice.beep()
      errors = app.diff.errors()

      for e in errors
        error =
          code: 1
          len: e.length
          word: e
          s: []

        out.push(error)

    if hook
      hook(out)
    else
      out
