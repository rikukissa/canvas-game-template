window.requestAnimFrame = ((callback) ->
  return window.requestAnimationFrame   || 
  window.webkitRequestAnimationFrame    || 
  window.mozRequestAnimationFrame       || 
  window.oRequestAnimationFrame         || 
  window.msRequestAnimationFrame        ||
  (callback) ->
    window.setTimeout callback, 1000 / 60
)()
window.d2r = 0.0174532925
window.logged = {}
window.log = (str) ->
  if !window.logged[str]
    console.log str
    window.logged[str] = true

class window.Collision
  constructor: (@collider, @target) ->
    cp = @collider.position
    cd = @collider.dimensions
    tp = @target.position
    td = @target.dimensions

    c =
      top: cp.y - cd.h / 2
      bottom: cp.y + cd.h / 2 
      right: cp.x + cd.w / 2
      left: cp.x - cd.w / 2
    t =
      top: tp.y - td.h / 2
      bottom: tp.y + td.h / 2 
      right: tp.x + td.w / 2
      left: tp.x - td.w / 2
    @collided = false
    if c.top < t.bottom and c.bottom > t.top and c.left < t.right and c.right > t.left
      @collided = true

class window.World
  constructor: (@type) ->
    @size =
      x: 0
      y: 0
    @bodies = []
  createBody: (b) ->
    b.parent = @
    @bodies.push b
  step: () ->
    for b in @bodies
      if b.alive
        @move b
  move: (b) ->
    if b.type == 'static'
      return
    if typeof b.onMove == 'function'
      b.onMove()

    b.position.y += Math.sin(b.angle) * b.forces.y
    b.position.x += Math.cos(b.angle) * b.forces.y
    b.angle += b.forces.s
    if b.userData == 'player'
      b.forces.s = 0

    # Check for collisions
    # o for other body
    for o in @bodies
      if o.id == b.id || !o.alive
        continue     
      
      # First go though the fixtures
      #for f in o.fixtures
      #  collision = new Collision b, f
      #  if collision.collided
      #    if typeof f.onCollision == 'function'
      #      f.onCollision b
      #    if typeof b.onCollision == 'function'
      #      b.onCollision f
      
      # Then the body itself       
      collision = new Collision b, o
      if collision.collided
        if typeof o.onCollision == 'function'
          o.onCollision b
        if typeof b.onCollision == 'function'
          b.onCollision o

class window.Keys
	constructor: () ->
    @up = false
    @down = false
    @left = false
    @right = false
    @space = false
    @commands =
      37: 'left'
      38: 'up'
      39: 'right'
      40: 'down'
      32: 'space'
    @loadEvents()
  loadEvents: () ->
    $(window).bind 'keydown keyup', (e) =>
      if @commands.hasOwnProperty e.keyCode
        e.preventDefault()
        @[@commands[e.keyCode]] = e.type == 'keydown'

class window.Assets
  constructor: (@arr) ->
    @asset = {}
    @loaded = 0

  load: (callback) ->
    if @arr.length == 0 || !@assets 
      callback()
      return
    for path in @arr
      @asset[path] = new Image()
      @asset[path].onload = () =>
        @loaded++
        if @loaded == @arr.length
          callback()
      @asset[path].src = path

class window.Camera
  constructor: (@canvas) ->
    @ctx = @canvas.getContext '2d'
    @position =
      x: 0
      y: 0
    @translation =
      x: 0
      y: 0
    @scale = 64
    @angle = Math.PI / 4
    @loadEvents()

  move: () ->
    @position.x += @translation.x
    @position.y += @translation.y
    @ctx.translate @position.x, @position.y

  loadEvents: () ->
    window.addEventListener 'mousemove', (e) =>
      if e.offsetX < 50
        @translation.x = 10
      else if e.offsetX > @canvas.width - 50
        @translation.x = -10
      else
        @translation.x = 0

      if e.offsetY < 50
        @translation.y = 10
      else if e.offsetY > @canvas.height - 50
        @translation.y = -10
      else
        @translation.y = 0

    window.addEventListener 'mouseout', () =>
      @translation.y = 0
      @translation.x = 0

class window.Debugger
  constructor: (@world) ->
  render: (ctx) ->
    cnv = ctx.canvas

    ctx.save()
    
    ctx.fillStyle = 'rgba(0, 0, 0, 0.2)'
    ctx.fillRect 0, 0, cnv.width, cnv.height
    ctx.restore()

class window.Body
  constructor: () ->
    @id = Math.floor(Math.random()*167772234242153422).toString(16)
    @position =
      x: 0
      y: 0
      z: 0
    @forces =
      x: 0
      y: 0
      z: 0
      s: 0
    @dimensions =
      w: 0
      d: 0     
      h: 0
    @angle = 0
    @fixtures = []
    @alive = true
    @type = 'static'
    @onMove = false
    @onCollision = false
  createFixture: (fix) ->
    fix.parent = @
    @fixtures.push fix

class window.Fixture
  constructor: () ->
    @id =  Math.floor(Math.random()*167772234242153422).toString(16)
    @position =
      x: 0
      y: 0
      z: 0
    @dimensions =
      w: 0
      d: 0
      h: 0
    @angle = 0
    @onCollision = false
  
  angleFromBodyCenter: () ->  
    return Math.atan(@position.y / @position.x)
  
  radiusToBodyCenter: () ->
    a = Math.pow(@position.x, 2)
    b = Math.pow(@position.y, 2)
    return Math.sqrt(a + b)    
  
  detach: () ->
    b = new Body
    b.type = 'dynamic'
    b.userData = 'fake'
    b.angle = @parent.angle + @angle

    rad = @radiusToBodyCenter()
    ang = @angleFromBodyCenter()
    b.position =
      x: @parent.position.x + rad * Math.cos((b.angle + ang))
      y: @parent.position.y + rad * Math.sin((b.angle + ang))
    
    log ang / d2r
    
    b.dimensions = @dimensions
    @parent.parent.createBody b