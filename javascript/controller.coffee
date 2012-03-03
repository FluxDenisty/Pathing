class window.Controller
  constructor: ({@model, @canvas}) ->
    foo = @clicked
    @canvas.click (e) ->
      foo({x:e.offsetX, y:e.offsetY})

    $(window).keypress (e) ->
      switch e.charCode
        when 32
          alert("place")
          break
        else

  @clicked: ({x, y}) ->
    @model.addPoint( new Point({x,y}) )
