class window.Controller
  constructor: ({@model, @canvas}) ->
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

  canvasClicked: ({x, y}) ->
    @model.addPoint( new Point({x,y}) )

  connectClicked: ->
    @model.connectGraph()
