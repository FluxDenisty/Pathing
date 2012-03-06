class window.Pathing
  constructor: () ->
    @currentPoints = []
    @allPoints = []
    @shapes = []
    @edges = []

  setView: (@view) ->

  addPoint: (point) ->
    @currentPoints.push point
    @allPoints.push point

  addEdge: (edge) ->
    @edges.push edge

  setShape: () ->
    if (@currentPoints.length > 2)
      @shapes.push new Polygon( @currentPoints )
    @currentPoints = []

  connectGraph: () ->
    for point in @allPoints
      console.log "word"
      @connectPoint point

  connectPoint: (point) ->
    for other in @allPoints
      if (point!=other && !@isConnected(point, other) && @visibleLine(point, other))
        edge = new Edge(point, other)
        @edges.push edge

  visibleLine: (one, two) ->
    for shape in @shapes
      if (shape.hits(one,two))
        console.log "hit shape"
        return false
    return true

  isConnected: (one, two) ->
    for edge in one.edges
      if (edge.two == one && edge.one == two)
        return true
      if (edge.one == one && edge.two == two)
        return true
    return false


class window.Point
  constructor: ({@x, @y}) ->
    @edges = []
    @shape = undefined

  addEdge: (edge) ->
    @edges.push edge

  draw: (ctx) ->
    ctx.fillStyle = "#8000FF"
    ctx.beginPath()
    ctx.arc(@x, @y, 5, 0, Math.PI * 2, false)
    ctx.fill()

class window.Polygon
  constructor: (@points) ->
    for point in @points
      point.shape = this
    if @points.length < 3
      throw "Broken Polygon Error"

  hits: (one, two) ->
    if (one.shape == two.shape)
      return true
    prev = @points[@points.length - 1]
    for next in @points
      yhit = false
      xhit = false
      left  = Math.min(prev.x, next.x)
      right = Math.max(prev.x, next.x)
      top   = Math.min(prev.y, next.y)
      bottom= Math.max(prev.y, next.y)
      if (left < one.x && one.x < right)
        xhit = true
      else if (left < two.x && two.x < right)
        xhit = true
      if (top < one.y && one.y < bottom)
        yhit = true
      else if (top < two.y && two.y < bottom)
        yhit = true

      if (xhit && yhit)
        return true
      prev = next
    return false

  draw: (ctx) ->
    ctx.fillStyle = "#8000FF"
    ctx.strokeStyle = "#9E3DFF"
    ctx.lineWidth = 3
    ctx.beginPath()
    lastPoint = @points[@points.length - 1]
    ctx.moveTo(lastPoint.x, lastPoint.y)
    for point in @points
      ctx.lineTo(point.x, point.y)
    ctx.fill()
    ctx.stroke()

class window.Edge
  constructor: (@one, @two) ->
    @xdist = Math.abs(@one.x - @two.x)
    @ydist = Math.abs(@one.y - @two.y)
    @weight = Math.sqrt(Math.pow(@xdist, 2) + Math.pow(@ydist, 2))
    @weight = Math.abs(@weight)
    @one.addEdge(this)
    @two.addEdge(this)

  draw: (ctx) ->
    ctx.strokeStyle = "#FFFF00"
    ctx.lineWidth = 2
    ctx.beginPath()
    ctx.moveTo(@one.x, @one.y)
    ctx.lineTo(@two.x, @two.y)
    ctx.stroke()
