@move_cursor = ->
  el    = input_box.get(0)
  nodes = el.childNodes
  count = nodes.length
  range = document.createRange()
  sel   = window.getSelection()

  # set cursor position
  range.setStart(nodes[count - 1], nodes[count - 1].length)
  range.collapse(true)
  sel.removeAllRanges()
  sel.addRange(range)
