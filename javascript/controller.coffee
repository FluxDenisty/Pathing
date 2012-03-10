class window.Controller
  constructor: ({@model, @canvas}) ->
    @mode = "create"
    @canvas.click (e) =>
      @canvasClicked({x:e.offsetX, y:e.offsetY})
    $("#connectButton").click (e) =>
      @connectClicked()

    $(window).keypress (e) =>
      switch e.charCode
        when 32
          @model.setShape()
          break
        else

  setView: (@view) ->

  canvasClicked: ({x, y}) ->
    if @mode == "create"
      @model.addPoint( new Point({x,y}) )
    else if @mode == "path"
      @view.drawGraph = false
      @model.pathPoint( new Point({x,y}) )

  connectClicked: ->
    if @mode = "create"
      @mode = "path"
      @model.connectGraph()
