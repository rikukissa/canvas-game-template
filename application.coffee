class Application
	constructor: () ->
    @canvas = $('canvas')[0]
    @ctx = @canvas.getContext '2d'
    @keys = new Keys
    @world = new World
    @camera = new Camera @canvas
  
  update: () ->
    @render()
    window.requestAnimFrame () =>
      @update()

  initialize: () ->
    @update()

  render: () ->
    # Make sure that canvas keeps the window dimensions
    @canvas.width = window.innerWidth
    @canvas.height = window.innerHeight

    # Save
    @ctx.save()

    # Keep the 0,0 point in the middle of the canvas
    @ctx.translate @canvas.width / 2, @canvas.height / 2

    # Restore
    @ctx.restore()

$(document).ready () ->
  app = new Application
  app.assets = new Assets([])
  app.assets.load () ->
    app.initialize()