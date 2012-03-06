class window.Display
  constructor: ({@model, @ctx, @canvas}) ->
    @drawGraph = true
    @draw()

  draw: ->
    ## DRAW BACKGROUND ##
    if !@radgrad?
      x = @canvas.width() / 2
      y = @canvas.height() / 2
      @radgrad = ctx.createRadialGradient(x, y, 1, x, y, x)
      @radgrad.addColorStop(0, '#0080FF')
      @radgrad.addColorStop(1, '#000066')
    @ctx.save()
    @ctx.fillStyle = @radgrad
    @ctx.fillRect(0, 0, @canvas.width() ,@canvas.height())
    @ctx.restore()

    ## DRAW POINTS ##
    @ctx.save()
    points = @model.currentPoints
    if points.length == 1
      points[0].draw(@ctx)
    else if points.length > 1
      @ctx.strokeStyle = "#8000FF"
      @ctx.beginPath()
      @ctx.moveTo(points[points.length - 1].x, points[points.length - 1].y)
      for point in points
        @ctx.lineTo(point.x, point.y)
      @ctx.stroke()
    @ctx.restore()

    ## DRAW SHAPES ##
    @ctx.save()
    for shape in @model.shapes
      shape.draw(@ctx)
    @ctx.restore()


    ## DRAW EDGES ##
    if @drawGraph
      @ctx.save()
      for edge in @model.edges
        edge.draw(@ctx)
      @ctx.restore()

    ## DRAW PATH ##
    @ctx.save()
    for edge in @model.path
      edge.draw(@ctx)
    @ctx.restore()

    requestAnimFrame => @draw()

#TODO: this is overdrawing. Something is broken
window.requestAnimFrame = window.requestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  window.oRequestAnimationFrame ||
  window.msRequestAnimationFrame ||
  (callback) ->
    window.setTimeout(callback, 1000 / 30);
