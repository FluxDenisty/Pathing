class window.Pathing
  constructor: () ->
    @currentPoints = []
    @allPoints = []
    @shapes = []
    @edges = []
    @path = []
    @from = undefined
    @to = undefined

  setView: (@view) ->

  addPoint: (point) ->
    @currentPoints.push point
    @allPoints.push point
    @view.modelChanged()

  addEdge: (edge) ->
    @edges.push edge

  setShape: () ->
    if (@currentPoints.length > 2)
      @shapes.push new Polygon( @currentPoints )
    @currentPoints = []
    @view.modelChanged()

  ## CONNECTION CODE ##

  connectGraph: () ->
    if @edges.length > 0
      for point in @allPoints
        point.edges = []
      @edges = []
    for shape in @shapes
      @connectShape shape
    for point in @allPoints
      @connectPoint point
    @view.modelChanged()

  connectShape: (shape) ->
    prev = shape.points[shape.points.length - 1]
    for next in shape.points
      edge = new Edge(prev, next)
      @edges.push edge
      prev = next

  connectPoint: (point) ->
    for other in @allPoints
      if (point!=other && !@isConnected(point, other) && @visibleLine(point, other))
        edge = new Edge(point, other)
        @edges.push edge

  visibleLine: (one, two) ->
    for shape in @shapes
      if (shape.hits(one,two))
        return false
    return true

  isConnected: (one, two) ->
    return @getConnection(one, two)?

  getConnection: (one, two) ->
    if (one == two)
      return undefined
    for edge in one.edges
      if (edge.two == one && edge.one == two)
        return edge
      if (edge.one == one && edge.two == two)
        return edge
    return undefined

  ## PATHING CODE ##

  pathPoint: (point) ->
    if !@from?
      @from = point
      @connectPoint @from
      @allPoints.push @from
    else
      if @to?
        @from = @to
      @to = point
      @connectPoint @to
      @allPoints.push @to
      @createPath()
    @view.modelChanged()

  createPath: ->
    for point in @allPoints
      point.weight = undefined
      point.parent = undefined
      point.state = "none"
    @from.weight = 0
    finished = []
    while finished.length < @allPoints.length
      # get unfinished point with lowest distance
      y = undefined
      for point in @allPoints
        if point.state != "done"
          if !y? && point.weight? || y?.weight? && y.weight > point.weight
            y = point
      if !y?
        console.log "SOMETHING BROKE"
        return
      # point has shortest path
      y.state = "done"
      finished.push y
      for z in @allPoints
        edge = @getConnection(y, z)
        if edge?
          #check if shorter path found
          if !z.weight? || y.weight + edge.weight < z.weight
            z.weight = y.weight + edge.weight
            z.parent = y
    # create path
    point = @to
    while point.parent?
      @path.push new Edge(point, point.parent)
      point = point.parent


  compare: (a, b) ->
    if a.weight < b.weight
      return -1
    else if a.weight > b.weight
      return 1
    else
      return 0



class window.Point
  constructor: ({@x, @y}) ->
    @edges = []
    @shape = undefined
    @weight = undefined
    @parent = undefined
    @state = "none"

  addEdge: (edge) ->
    @edges.push edge

  getOther: (edge) ->
    if (edge.one == this)
      return edge.two
    else
      return edge.one

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
      if (prev != one && prev != two && next != one && next != two)
        if @intersect(one, two, prev, next)
          return true
      prev = next
    return false

  ## WRINEAR ARGEBRAWR ##
  ccw: (A,B,C) ->
    return (C.y-A.y)*(B.x-A.x) > (B.y-A.y)*(C.x-A.x)

  intersect: (A,B,C,D) ->
    return @ccw(A,C,D) != @ccw(B,C,D) and @ccw(A,B,C) != @ccw(A,B,D)

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


