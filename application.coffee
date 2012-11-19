# This is an example script to demonstrate the features of this template
asteroid = false
class Application
  constructor: () ->
    @canvas = $('canvas')[0]
    @ctx = @canvas.getContext '2d'
    @keys = new Keys
    @world = new World('2d')
    @camera = new Camera @canvas
  
    @player = null
  update: () ->
    @render()
    window.requestAnimFrame () =>
      @update()

  initialize: () ->
    # Create our player object
    @player = new Body
    @player.type = 'dynamic'
    
    @player.userData = 'player'
    @player.position =
      x: 0
      y: 0
    @player.dimensions =
      w: 20 # Width
      h: 30 # Height

    @player.shootLock = false
    @player.shoot = () =>
      if @player.shootLock
        return
      @player.shootLock = true
      
      bullet = new Body
      bullet.type = 'dynamic'
      bullet.userData = 'bullet'
      bullet.position =
        x: @player.position.x + (@player.dimensions.w / 2 + 10) * Math.cos(@player.angle)
        y: @player.position.y + (@player.dimensions.h / 2 + 10) * Math.sin(@player.angle)
      bullet.dimensions =
        w: 5
        h: 5
      bullet.onCollision = (b) ->
        if b.userData == 'asteroid'
          @alive = false

      bullet.angle = @player.angle
      bullet.forces.y = 5
      @world.createBody bullet

    # Now we can add the body to our world
    @world.createBody @player

    # Lets create an asteroid
    asteroid = new Body
    asteroid.type = 'dynamic'
    asteroid.userData = 'asteroid'
    asteroid.position =
      x: 0
      y: -150
    asteroid.dimensions =
      w: 100
      h: 100
    asteroid.angle = -90 * d2r
    # asteroid.angle = Math.random() * (360 * Math.PI/180)
    #asteroid.forces.s = 0.01
    for i in [0..0]
      fxt = new Fixture
      fxt.dimensions =
        w: Math.random() * asteroid.dimensions.w
        h: Math.random() * asteroid.dimensions.h
      #fxt.angle = Math.random() * (360 * Math.PI/180)
      fxt.position =
        x: -50
        y: 50
        #x: asteroid.dimensions.w * (Math.random() * -1 + 0.5)
        #y: asteroid.dimensions.h * (Math.random() * -1 + 0.5)
      
      asteroid.createFixture fxt
      
      console.log 'Asd:', asteroid.angle / d2r
      console.log 'Fxt:', fxt.position.x, fxt.position.y
    
    asteroid.onCollision = (b) =>
      if b.userData != 'bullet'
        return
      for f in asteroid.fixtures
        f.detach()
    @world.createBody asteroid
    @update()
  
  render: () ->
    cnv = @canvas
    ctx = @ctx
    
    if @keys.up
      @player.forces.y += 0.1 if @player.forces.y < 4
    if @keys.down
      @player.forces.y -= 0.1 if @player.forces.y > 0
    if @keys.left
      @player.forces.s -= 0.1
    if @keys.right
      @player.forces.s += 0.1

    if @keys.space
      @player.shoot()
    else
      @player.shootLock = false
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
      if !b.alive
        continue
      pos = b.position
      dim = b.dimensions
      ctx.save()
      ctx.translate pos.x, pos.y
      ctx.rotate b.angle
      
      # Draw body
      ctx.fillStyle = 'rgba(0, 100, 0, 0.5)'
      ctx.strokeStyle = 'rgba(0, 150, 0, 1)'
      ctx.fillRect -dim.w / 2, 0 - dim.h / 2, dim.w, dim.h
      ctx.strokeRect -dim.w / 2, 0 - dim.h / 2, dim.w, dim.h
      
      # Draw fixtures
      for f in b.fixtures
        ctx.save()
        pos = f.position
        dim = f.dimensions
        ctx.rotate f.angle
        ctx.fillRect pos.x - dim.w / 2, pos.y - dim.h / 2, dim.w, dim.h
        ctx.strokeRect pos.x - dim.w / 2, pos.y - dim.h / 2, dim.w, dim.h
        ctx.restore()
      
      ctx.restore()

    # Restore
    @ctx.restore()

$(document).ready () ->
  app = new Application
  app.assets = new Assets([])
  app.assets.load () ->
    app.initialize()