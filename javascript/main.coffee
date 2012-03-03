$ ->
  window.canvas = $('#drawable')
  window.ctx = canvas.get(0).getContext('2d')
  model = new Pathing()
  control = new Controller {model, canvas}
  view = new Display {model, ctx, canvas}
  model.setView view
