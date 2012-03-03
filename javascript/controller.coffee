class window.Controller
  constructor: ({@model, @canvas}) ->
    @canvas.click (e) =>
      @clicked({x:e.offsetX, y:e.offsetY})

    $(window).keypress (e) =>
      switch e.charCode
        when 32
          @model.setShape()
          break
        else

  clicked: ({x, y}) ->
    console.log @model
    @model.addPoint( new Point({x,y}) )
