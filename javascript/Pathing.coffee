class window.Pathing
  constructor: () ->
    @points = []
    @shapes = []

  setView: (@view) ->

  addPoint: (point) ->
    @points.push point

  setShape: () ->
    if (@points.length > 2)
      @shapes.push new Polygon( @points )
    @points = []



class window.Point
  constructor: ({@x, @y}) ->

  draw: (ctx) ->
    ctx.fillStyle = "#8000FF"
    ctx.beginPath()
    ctx.arc(@x, @y, 5, 0, Math.PI * 2, false)
    ctx.fill()

class window.Polygon
  constructor: (@points) ->
    if @points.length < 3
      throw "Broken Polygon Error"

  draw: (ctx) ->
    ctx.fillStyle = "#8000FF"
    ctx.strokeStyle = "#9E3DFF"
    ctx.lineWidth = 3
    ctx.beginPath()
    ctx.moveTo(@points[@points.length - 1].x, @points[@points.length - 1].y)
    for point in @points
      ctx.lineTo(point.x, point.y)
    ctx.fill()
    ctx.stroke()

