# This is an example script to demonstrate the features of this template

class Application
  constructor: () ->
    @canvas = $('canvas')[0]
    @ctx = @canvas.getContext '2d'
    @keys = new Keys
    @world = new World('2d')
    @camera = new Camera @canvas
    @debug = new Debugger @world
  
    @player = null
  update: () ->
    @render()
    window.requestAnimFrame () =>
      @update()

  initialize: () ->
    @update()
    
    # Lets our player to world
    @player = new Body
    @player.position =
      x: 0
      y: 0
    @player.dimensions =
      w: 30 # Width
      h: 20 # Height
    @player.shootLock = false
    @player.shoot = () =>
      if @player.shootLock
        return

      # @player.shootLock = true
      
      bullet = new Body
      bullet.position =
        x: @player.position.x
        y: @player.position.y
      bullet.dimensions =
        w: 5
        h: 5
      bullet.angle = @player.angle
      bullet.forces.y = 2
      @world.createBody bullet


    # Now we can add the body to our world
    @world.createBody @player
  
  render: () ->
    cnv = @canvas
    ctx = @ctx
    
    if @keys.up
      @player.forces.y -= 0.1
    if @keys.down
      @player.forces.y += 0.1
    if @keys.left
      @player.forces.s -= 0.1
    if @keys.right
      @player.forces.s += 0.1

    if @keys.space
      @player.shoot()

    @world.step()

    # Make sure that canvas keeps the window dimensions
    if cnv.width != window.innerWidth || cnv.height != window.innerHeight
      cnv.width = 2 * Math.round(window.innerWidth / 2)
      cnv.height = 2 * Math.round(window.innerHeight / 2);

    # Save
    ctx.save()
    ctx.clearRect 0, 0, cnv.width, cnv.height
    
    # Keep the 0,0 point in the middle of the canvas
    ctx.translate cnv.width / 2, cnv.height / 2
    
    # DEBUG - Center of the universe
    ctx.fillStyle = 'red'
    ctx.beginPath()
    ctx.arc(0, 0, 2, 0, Math.PI * 2, false)
    ctx.closePath()
    ctx.fill()
    
    for b in @world.bodies
      pos = b.position
      dim = b.dimensions
      ctx.save()
      ctx.translate pos.x, pos.y
      ctx.rotate b.angle
      # console.log b.angle
      ctx.fillStyle = 'rgba(0, 100, 0, 0.5)'
      ctx.strokeStyle = 'rgba(0, 150, 0, 1)'
      ctx.fillRect 0 - dim.w / 2, 0 - dim.h / 2, dim.w, dim.h
      ctx.strokeRect 0 - dim.w / 2, 0 - dim.h / 2, dim.w, dim.h
      ctx.restore()
    
    # Restore
    @ctx.restore()

$(document).ready () ->
  app = new Application
  app.assets = new Assets([])
  app.assets.load () ->
    app.initialize()