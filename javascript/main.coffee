$ ->
  #TODO: take these off window
  window.canvas = $('#drawable')
  window.ctx = canvas.get(0).getContext('2d')
  window.model = new Pathing()
  control = new Controller {model, canvas}
  view = new Display {model, ctx, canvas}
  control.setView(view)
  model.setView view
