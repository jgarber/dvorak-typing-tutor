class App.Scayt
  #some string herep
  #[{"code":1,"pos":0,"row":0,"col":0,"len":5,"word":"herep","s":["here"]}]
  check: (text, hook) =>
    console.log(text)
    hook([])
