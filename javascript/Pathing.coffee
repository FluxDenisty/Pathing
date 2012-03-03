class window.Pathing
  constructor: () ->
    @points = []
    @shapes = []

  @setView: (@view) ->

  @addPoint: (point) ->
    @points.push point



class window.Point
  constructor: ({@x, @y}) ->

  

class window.Polygon
  constructor: (@points) ->

