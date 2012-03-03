class window.Display
  constructor: ({@model, @ctx, @canvas}) ->
    @draw()

  @draw: ->
    ## DRAW BACKGROUND ##
    x = @canvas.width() / 2
    y = @canvas.height() / 2
    radgrad = ctx.createRadialGradient(x, y, 1, x, y, x)
    radgrad.addColorStop(0, '#0080FF')
    radgrad.addColorStop(1, '#000066')
    @ctx.fillStyle = radgrad
    @ctx.fillRect(0, 0, @canvas.width() ,@canvas.height())

    ## DRAW POINTS ##
    points = @model.points
    if points.length == 1
      @ctx.fillStyle = "#8000FF"
      @ctx.beginPath()
      @ctx.arc(points[0].x, points[0].y, 3, 0, Math.PI * 2, false)
      @ctx.fill

    requestAnimFrame @draw


window.requestAnimFrame = (callback) ->
    return window.requestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    (callback) ->
        window.setTimeout(callback, 1000 / 60);
